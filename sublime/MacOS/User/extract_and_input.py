import sublime
import sublime_plugin
import os
import re

class ExtractAndInput(sublime_plugin.TextCommand):
    def run(self, edit):
        view = self.view
        self.region = view.sel()[0]
        content = view.substr(self.region)
        sublime.set_clipboard(content)
        match = re.search(r"\\section{(.+?)}", content)
        if match:
            replace = "\\input{%s}" % match.group(1)
            view.replace(edit, view.sel()[0], replace)
            current = view.file_name()
            new_file = "%s.tex" % match.group(1)
            path = os.path.normpath(os.path.join(current, "..", new_file))
            with open(path, "a") as file_obj:
                file_obj.write("% Generated using ExtractAndInput Plugin\n")
                file_obj.write(content)