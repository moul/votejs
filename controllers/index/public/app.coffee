(($, document, window, console) ->

    class VoteJS
        constructor: (@options) ->
            do @handleOptions
            @polls = {}
            @pollVotes = {}
            @publicPolls = []
            @currentPoll = null

        handleOptions: =>
            @options.base_url ?= ''

        onError: (error) =>
            console.log "ERROR!!!", error

        call: (options) ->
            options.url       = "#{@options.base_url}/#{options.url}"
            options.dataType ?= 'jsonp'
            options.data     ?= {}
            options.data.userId   ?= @options.userId
            options.error    ?= (error) => @onError error
            console.log 'call param', options
            $.ajax options

        fetchPoll: (id, fn = null) =>
            @call
                url: "poll/#{id}/json"
                success: (data) =>
                    @polls[data.id] = data
                    fn data if fn

        fetchPollVotes: (id, fn = null) =>
            @call
                url: "poll/#{id}/votes/json"
                success: (data) =>
                    @pollVotes[id] = data
                    fn data if fn

        vote: (pollId, answerId, fn = null) =>
            @call
                url: "poll/#{pollId}/vote"
                type: "POST"
                data:
                    answerId: answerId
                success: (data) =>
                    console.log data
                    fn data if fn

        userIdUpdate: (userId) =>
            @options.userId = userId
            console.log "Logged as #{userId}"

        refreshPublicList: (fn = null) =>
            @call
                url: "polls/json"
                success: (@publicPolls) =>
                    do @onPublicPollsListUpdate
                    do fn if fn

    class VoteJsApp extends VoteJS
        handleOptions: =>
            @userIdUpdate @options.userId if @options.userId
            super

        onPublicPollsListUpdate: =>
            console.log 'test'
            console.log @publicPolls
            for poll in @publicPolls
                row = $('<tr/>')
                row.append $('<td/>').html poll.question
                actions = $('<td/>')
                that = @
                view_button = $('<button/>').data('id', poll.id).addClass('btn').html('view').click ->
                    id = parseInt $(@).data 'id'
                    that.fetchPoll id, (data) -> that.switchToPoll data.id
                row.append view_button
                @options.container_publicPollsList.append row

        switchToPoll: (id) =>
            @currentPoll = id
            switchTo '#poll-view'
            console.log 'switchToPoll', @polls[id]

        _displayPoll: =>
            poll = @polls[@currentPoll]
            $('#poll-view h1').html poll.question
            that = @
            for key, answer of poll.answers
                console.log answer
                vote_button = $('<button/>').data('id', key).addClass('btn').html(answer).click ->
                    that.vote that.currentPoll, $(@).data('id'), that.updatePollVotes
                $('#poll-view .answers').append vote_button
            @fetchPollVotes @currentPoll, @displayPollVotes

        updatePollVotes: =>
            if @currentPoll
                @fetchPollVotes @currentPoll, @displayPollVotes

        displayPollVotes: =>
            console.log "display poll votes", @pollVotes[@currentPoll]
            $('#poll-view .stats').empty()
            for answerId, answerCount of @pollVotes[@currentPoll].votes
                answer = @polls[@currentPoll].answers[answerId]
                $('#poll-view .stats').append "<div>#{answer} : #{answerCount}</div>"

        displayPoll: =>
            if not @currentPoll
                switchTo '#home'
                return
            if not @polls[@currentPoll]
                @fetchPoll @currentPoll, @_displayPoll
            else
                do @_displayPoll

    $(document).ready ->
        userId = $('meta[name="userId"]').attr('content') || false
        pollId = parseInt($('meta[name="pollId"]').attr('content')) || false
        $('#list-public').click ->
            switchTo '#public-list'

        $('#user-id-form .input').val(userId) if userId
        $('#user-id-form .submit').click ->
            window.voteJs.userIdUpdate $('#user-id-form .input').val()
        voteJs = window.voteJs = new VoteJsApp
            base_url: ''
            container_publicPollsList: $('.public-polls-list')
            userId: userId
        voteJs.currentPoll = pollId
        setInterval voteJs.updatePollVotes, 1000

)(jQuery, document, window, console)