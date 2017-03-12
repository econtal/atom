# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

# DOC: https://atom.io/docs/api/v1.9.4/TextEditor

atom.commands.add 'atom-text-editor',
  # Scroll the view such that the line containing
  # the cursor is vertically centered in the view.
  'dot-atom:scroll-cursor-to-center': ->
    editor = atom.workspace.getActiveTextEditor()
    textEditorElement = atom.views.getView(editor)
    cursorPosition = editor.getCursorScreenPosition()
    pixelPositionForCursorPosition =
      textEditorElement.pixelPositionForScreenPosition(cursorPosition)
    halfScreenHeight = editor.getHeight() / 2
    scrollTop = pixelPositionForCursorPosition.top - halfScreenHeight
    editor.setScrollTop(scrollTop)

  # Delete surrounding spaces
  'dot-atom:delete-surrounding-spaces': ->
    editor = atom.workspace.getActiveTextEditor()
    editor.moveToEndOfWord()
    editor.moveToBeginningOfWord()
    editor.selectToBeginningOfWord()
    editor.selectToEndOfWord()
    editor.cutSelectedText()

  # Insert debug breakpoint
  'dot-atom:insert-debug-breakpoint': ->
    editor = atom.workspace.getActiveTextEditor()
    grammar = editor.getGrammar()
    if grammar.name == 'Python'
      text = 'import pdb; pdb.set_trace()'
    editor.insertNewlineAbove()
    editor.autoIndentSelectedRows()
    editor.insertText(text)

  # [Tab] goes to first word when on first char of line
  'dot-atom:indent-and-go-to-first-word': ->
    editor = atom.workspace.getActiveTextEditor()
    editor.autoIndentSelectedRows()
    pos = editor.getCursorBufferPosition()
    if pos.column == 0
      editor.moveToFirstCharacterOfLine()
