(($, document, window, console) ->

    window.switchTo = (selector, before, after) ->
        if selector == 'back'
            return switchTo window.switchPrevious
        else if selector == 'parent'
            return switchTo $('.appPage:not(.hide)').attr('data-switch-parent')

        previous = $('.appPage:not(.hide)')

        $(".appPage:not(#{selector})").addClass 'hide'
        do before if before

        $(selector).removeClass 'hide'
        document.location.hash = selector

        switchedAction = $(selector).data 'switched-action'
        eval switchedAction if switchedAction

        if window.switchPrevious != previous
            window.switchPrevious = previous

        do after if after

        false

    $(document).ready ->
        setTimeout (->
            hash = document.location.hash
            obj = false
            if hash.length > 1
                obj = $(".appPage#{hash}")
                if obj
                    switchTo hash
            if not obj
                switchTo '#home'
            ), 1

)(jQuery, document, window, console)
