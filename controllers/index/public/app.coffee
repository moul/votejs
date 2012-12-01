(($, document, window, console) ->

    class VoteJS
        constructor: (@options) ->
            do @handleOptions
            @polls = {}
            @publicPolls = []
            @currentPoll = null

        handleOptions: =>
            @options.base_url ?= ''

        onError: (error) =>
            console.log "ERROR!!!", error

        call: (options) ->
            options.url       = "#{@options.base_url}/#{options.url}"
            options.dataType ?= 'jsonp'
            options.error    ?= (error) => @onError error
            $.ajax options

        fetchPoll: (id, fn = null) =>
            @call
                url: "poll/#{id}/json"
                success: (data) =>
                    @polls[data.id] = data
                    fn data if fn

        refreshPublicList: (fn = null) =>
            @call
                url: "polls/json"
                success: (@publicPolls) =>
                    do @onPublicPollsListUpdate
                    do fn if fn

    class VoteJsApp extends VoteJS
        handleOptions: =>
            console.log 'cool'
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

        displayPoll: =>
            if not @currentPoll
                switchTo '#home'
                return
            poll = @polls[@currentPoll]
            $('#poll-view h1').html poll.question

    $(document).ready ->
        $('#list-public').click ->
          switchTo '#public-list'

        window.voteJs = new VoteJsApp
            base_url: ''
            container_publicPollsList: $('.public-polls-list')

)(jQuery, document, window, console)