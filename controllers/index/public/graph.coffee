(($, document, window, console) ->

    class GraphCool
        constructor: (@options) ->
            do @handleOptions
            do @build
            do @render
            return @

        handleOptions: =>
            @datas = @options.datas
            @container = @options.container
            @positions = []

        getMax: =>
            @max = 0
            for key, entry of @datas
                @max = Math.max @max, entry.val

        build: =>
            @ul = $('<ul/>').addClass 'bars'
            @container.append @ul

            do @getMax

            i = 0
            for key, entry of @datas
                entry.key = key
                entry.title ?= key
                entry.titleSpan = $('<span/>').addClass('title').html entry.title
                entry.row = $('<li/>').addClass 'row'
                entry.bar = $('<div/>').addClass 'bar'
                entry.percent = $('<span/>').addClass('percent')
                entry.row.append entry.titleSpan
                entry.row.append entry.percent
                entry.row.append entry.bar

                @ul.append entry.row
                @positions.push entry.row.position()
                entry.i = i++

            console.log 'datas', @datas

            for key, entry of @datas
                entry.row.css
                    position: 'absolute'
                    top: @positions[entry.i].top

        render: =>
            for key, entry of @datas
                @renderEntry key
            entries = [entry for key, entry of @datas][0]
            entries.sort (a, b) -> return a.val > b.val
            i = 0
            for entry in entries
                entry.i = i
                @goToPosition entry.key, entries.length - 1 -i
                i++

        renderEntry: (key) =>
            entry = @datas[key]
            entry.percent.html "#{entry.val}"
            if @max > 0
                entry.bar.animate {'width': "#{entry.val / @max * 100}%"}, 300
            else
                entry.bar.css 'width', 0


        updateVal: (key, newValue) =>
            @datas[key].val = newValue

        updateVals: (vals) =>
            @updateVal key, value for key, value of vals
            do @getMax
            do @render

        goToPosition: (key, position) =>
            row = @datas[key].row
            row.stop().animate { 'top': @positions[position].top }

        swap: (a, b) =>
            positionA = @positions[@datas[a].i]
            positionB = @positions[@datas[b].i]

            @datas[a].row.stop().animate { 'top': positionB.top }
            @datas[b].row.stop().animate { 'top': positionA.top }

            [@datas[a].i, @datas[b].i] = [@datas[b].i, @datas[a].i]

    window.GraphCool = GraphCool

    $(document).on 'rien', ->
        graph = new GraphCool
            container: $('#container')
            datas:
                0:
                    title: 'bah votejs'
                    val: 0
                1:
                    title: 'ah, il y a d\'autre projets ?'
                    val: 0
                2:
                    title: 'il etait une fois dans l\'ouest'
                    val: 0
                3:
                    title: 'un sandwich vaut mieux que 2 casquettes'
                    val: 0

        setTimeout (->
            graph.updateVals
                'bah votejs': 12
                'ah, il y a d\'autre projets ?': 13
                'il etait une fois dans l\'ouest': 41
                'un sandwich vaut mieux que 2 casquettes': 50
            ), 500


        setTimeout (->
            #graph.goToPosition 'a', 3
            graph.updateVals
                'bah votejs': 12
                'ah, il y a d\'autre projets ?': 24
                'il etait une fois dans l\'ouest': 2
                'un sandwich vaut mieux que 2 casquettes': 49
            ), 1000

)(jQuery, document, window, console)
