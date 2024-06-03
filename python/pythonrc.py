import readline
readline.write_history_file = lambda *_: None
del readline
