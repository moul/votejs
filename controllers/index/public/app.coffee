(($, document, window, console) ->

    class VoteJS
        constructor: (@options) ->
            do @handleOptions
            @polls = {}
            @pollVotes = {}
            @pollOwns = {}
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
            $.ajax options

        fetchPoll: (id, fn = null) =>
            @call
                url: "poll/#{id}/json"
                ioPath: 'poll'
                data:
                    pollId: id
                success: (data) =>
                    @polls[data.id] = data
                    fn data if fn

        fetchPollVotes: (id, fn = null) =>
            @call
                url: "poll/#{id}/votes/json"
                ioPath: 'pollVotes'
                data:
                    pollId: id
                success: (data) =>
                    @pollVotes[id] = data
                    fn data if fn

        vote: (pollId, answerId, fn = null) =>
            @call
                url: "poll/#{pollId}/vote"
                ioPath: 'pollVoteCreate'
                type: "POST"
                data:
                    answerId: answerId
                    pollId: pollId
                success: (data) =>
                    fn data if fn

        createPoll: (poll, fn = null) =>
            @call
                url: "poll"
                ioPath: 'pollCreate'
                type: 'POST'
                data: poll

        fetchPrivatePoll: (secret, fn = null) =>
            @call
                ioPath: 'getPrivate'
                data:
                    secret: secret
                success: (poll) =>
                    if poll
                        @polls[poll.id] = poll
                        @switchToPoll(poll.id)
                    else
                        $('#footer .notification').html '<p class="text-error">Poll not found</p>'

        userIdUpdate: (userId) =>
            @options.userId = userId
            console.log "Logged as #{userId}"

        refreshPublicList: (fn = null) =>
            @call
                ioPath: 'polls'
                url: "polls/json"
                success: (@publicPolls) =>
                    do @onPublicPollsListUpdate
                    do fn if fn

    class VoteJsApp extends VoteJS
        handleOptions: =>
            do @initSocket
            @userIdUpdate @options.userId if @options.userId
            super

        initSocket: =>
            setInterval voteJs.updatePollVotes, 1000

        onPublicPollsListUpdate: =>
            @options.container_publicPollsList.empty()
            for poll in @publicPolls
                row = $('<tr/>')
                row.append $('<td/>').html poll.question
                actions = $('<td/>')
                that = @
                view_button = $('<button/>').data('id', poll.id).addClass('btn btn-primary').html('view').click ->
                    id = parseInt $(@).data 'id'
                    that.fetchPoll id, (data) -> that.switchToPoll data.id
                row.append $('<td/>').html(view_button)
                @options.container_publicPollsList.append row

        switchToPoll: (id) =>
            @currentPoll = id
            switchTo '#poll-view'

        _displayPoll: =>
            do @initGraph
            poll = @polls[@currentPoll]
            $('#poll-view h1').html poll.question
            that = @
            $('#poll-view .answers').empty()
            for key, answer of poll.answers
                vote_button = $('<button/>').data('id', key).addClass('btn').html(answer).click ->
                    that.vote that.currentPoll, $(@).data('id'), that.updatePollVotes
                $('#poll-view .answers').append vote_button
            @fetchPollVotes @currentPoll, @displayPollVotes

        updatePollVotes: =>
            if @currentPoll
                @fetchPollVotes @currentPoll, @displayPollVotes

        initGraph: =>
            if @graph
                do @graph.destruct
                delete @graph
            datas = {}
            for key, answer of @polls[@currentPoll].answers
                datas[key] =
                    title: answer.toString()
                    val: 0
            @graph = new GraphCool
                container: $('#poll-view .stats')
                datas: datas

        displayPollVotes: =>
            @graph.updateVals @pollVotes[@currentPoll]

        displayPoll: =>
            if not @currentPoll
                switchTo '#home'
                return
            if not @polls[@currentPoll]
                @fetchPoll @currentPoll, @_displayPoll
            else
                do @_displayPoll

    class VoteJsAppSocketIO extends VoteJsApp
        initSocket: =>
            @io = io.connect()
            @io.on 'connect', =>
                console.log 'connected !'
            @io.on 'pollVotesUpdate', (data) =>
                console.log 'pollVotesUpdate', data
                @pollVotes[data.pollId] = data.votes
                do @displayPollVotes

        call: (options) ->
            options.data          ?= {}
            options.data.userId   ?= @options.userId
            options.data.args     ?= options.ioArgs
            console.log "calling #{options.ioPath}"
            @io.emit options.ioPath, options.data, options.success

    $(document).ready ->
        userId = $('meta[name="userId"]').attr('content') || false
        pollId = parseInt($('meta[name="pollId"]').attr('content')) || false

        $('.public-list-btn').click ->
            switchTo '#public-list'
        $('.account-btn').click ->
            switchTo '#account'
        $('.private-btn').click ->
            switchTo '#private'
        $('.new-poll-btn').click ->
            switchTo '#new-poll'
        $('#private .poll-secret-submit').click ->
            voteJs.fetchPrivatePoll $('#private .poll-secret').val()
        $('.new-poll-submit').click ->
            voteJs.createPoll
                question: $('.new-poll-form .poll-question').val()
                answers: $('.new-poll-form .poll-answers').val().split('\n')
                secret: $('.new-poll-form .poll-secret').val()
        $('#user-id-form .input').val(userId) if userId
        $('#user-id-form .submit').click ->
            window.voteJs.userIdUpdate $('#user-id-form .input').val()
        voteJs = window.voteJs = new VoteJsAppSocketIO
            base_url: ''
            container_publicPollsList: $('.public-polls-list tbody')
            userId: userId
        voteJs.currentPoll = pollId

)(jQuery, document, window, console)