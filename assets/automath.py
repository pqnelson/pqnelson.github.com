from pygments import highlight
from pygments.lexer import RegexLexer, bygroups
from pygments.token import *
from pygments.formatters import HtmlFormatter

class AutomathLexer(RegexLexer):
    name = 'Automath'
    aliases = ['aut']
    filenames = ['*.aut']
    identifier = '([a-zA-Z0-9_\'\`\-]+)'
    typeIdentifier  = '([a-zA-Z0-9_\'\`\-\[\:,\]]+)'
    semi = '(\'E\'|;|\:)'
    assignment = '(\:=)'
    ws='(\s*)'
    tokens = {
        'root': [
            (r'\[\s*'+identifier+'\s*[\:,]\s*'+identifier+'\s*\]', Text),
            (r"[\*@]", Operator),
            # Name.Class : Keyword.Pseudo := Name.Function
            (r''+identifier+ws+semi+ws+typeIdentifier+ws+assignment+ws+identifier,
             bygroups(Name.Class, Text, Operator, Text, Keyword.Pseudo, Text, Operator, Text, Name.Function)),
            # Name.Class := Name.Function : Keyword.Pseudo
            (r''+identifier+ws+assignment+ws+identifier+ws+semi+ws+typeIdentifier,
             bygroups(Name.Class, Text, Operator, Text, Name.Function, Text, Operator, Text, Keyword.Pseudo)),
            (r''+identifier, Name.Variable),
            (r'\n', Text),
            (r'\s+', Text),
            (r'#.*?\n', Comment), 
           (r'\{[^\}]*\}', Comment.Multiline),
        ],
    }

code = "# The following snippet\n# >>> a *         [b:prop] imp : prop := PRIM\n# >>>   * [p:[z:term]prop] for : prop := PRIM\n# expands to:\na * b : prop := ---\nb * imp : prop := PRIM\n  * p : [z:term]prop := ---\np * for : prop := PRIM"
print highlight(code, AutomathLexer(), HtmlFormatter())
