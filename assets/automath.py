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
            (r"^[+\-]", Operator),
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

code = "+ p1\n# ...\n- p1\n+ p2\n# ...\n- p2\n+ p3\n# ...\n- p3\n# etc."
print highlight(code, AutomathLexer(), HtmlFormatter())
