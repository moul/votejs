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
            console.log 'call param', options
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
                    console.log data
                    fn data if fn

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
            if not @graph? and not @graph
                datas = {}
                for key, answer of @polls[@currentPoll].answers
                    datas[key] =
                        title: answer.toString()
                        val: 0
                console.log 'datas', datas
                @graph = new GraphCool
                    container: $('#poll-view .stats')
                    datas: datas

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
            console.log 'io connect'
            @io = io.connect()
            @io.on 'connect', =>
                console.log 'connected !'
            @io.on 'pollVotesUpdate', (data) =>
                console.log data
                @pollVotes[data.pollId] = data.votes
                do @displayPollVotes

        call: (options) ->
            #url = options.url.split /\//
            options.data          ?= {}
            options.data.userId   ?= @options.userId
            #options.data.args     ?= url[1..]
            options.data.args     ?= options.ioArgs
            #console.log "calling #{url[0]}"
            console.log "calling #{options.ioPath}"
            #@io.emit url[0], options.data, options.success
            @io.emit options.ioPath, options.data, options.success

    $(document).ready ->
        userId = $('meta[name="userId"]').attr('content') || false
        pollId = parseInt($('meta[name="pollId"]').attr('content')) || false
        $('.public-list-btn').click ->
            switchTo '#public-list'
        $('#new-poll').click ->
            switchTo '#new-poll'
        $('#user-id-form .input').val(userId) if userId
        $('#user-id-form .submit').click ->
            window.voteJs.userIdUpdate $('#user-id-form .input').val()
        voteJs = window.voteJs = new VoteJsAppSocketIO
            base_url: ''
            container_publicPollsList: $('.public-polls-list')
            userId: userId
        voteJs.currentPoll = pollId

)(jQuery, document, window, console)