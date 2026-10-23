((comment) @injection.content
  (#set! injection.language "comment"))

; Keep separate instructions out of the same Bash syntax tree.
((shell_command) @injection.content
  (#set! injection.language "bash")
  (#set! injection.include-children))

((run_instruction
  (heredoc_block) @injection.content)
  (#set! injection.language "bash")
  (#set! injection.include-children))
