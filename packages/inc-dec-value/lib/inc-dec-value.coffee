rMatchNumber = /(-*[0-9]+(?:\.[0-9]+)?)([^0-9]*)?/

transform = ( editor, up, amount = 1 ) ->

    editor.selectWord()

    aRanges = editor.getSelectedBufferRanges()

    for oCurrentWordRange in aRanges

        sCurrentWord = editor.getTextInBufferRange(oCurrentWordRange)

        # Number
        if aMatches = sCurrentWord.match rMatchNumber
            iCurrentNumber = parseFloat aMatches[ 1 ]
            iNewNumber = if up then iCurrentNumber + amount else iCurrentNumber - amount
            sNewText = "#{ iNewNumber }" + if aMatches[ 2 ]? then aMatches[ 2 ] else ""
        else
            # Keywords
            sNewText = switch sCurrentWord
                when "false" then "true"
                when "true" then "false"
                when "FALSE" then "TRUE"
                when "TRUE" then "FALSE"
                when "yes" then "no"
                when "no" then "yes"
                when "on" then "off"
                when "off" then "on"

        unless sNewText
            if sCurrentWord is sCurrentWord.toLowerCase()
                sNewText = sCurrentWord.charAt( 0 ).toUpperCase() + sCurrentWord.substring( 1 ).toLowerCase()
            else if sCurrentWord.charAt( 0 ) is sCurrentWord.charAt( 0 ).toUpperCase() and sCurrentWord.charAt( 1 ) is sCurrentWord.charAt( 1 ).toLowerCase()
                sNewText = sCurrentWord.toUpperCase()
            else
                sNewText = sCurrentWord.toLowerCase()

        if sNewText
            editor.setTextInBufferRange oCurrentWordRange, "#{ sNewText }"

module.exports =
    activate: ->
        atom.commands.add "atom-text-editor", "inc-dec-value:increment", ->
            currentPane = atom.workspaceView.getActivePaneItem()
            transform currentPane, yes
        atom.commands.add "atom-text-editor", "inc-dec-value:decrement", ->
            currentPane = atom.workspaceView.getActivePaneItem()
            transform currentPane, no
        atom.commands.add "atom-text-editor", "inc-dec-value:increment-by-decade", ->
            currentPane = atom.workspaceView.getActivePaneItem()
            transform currentPane, yes, 10
        atom.commands.add "atom-text-editor", "inc-dec-value:decrement-by-decade", ->
            currentPane = atom.workspaceView.getActivePaneItem()
            transform currentPane, no, 10
