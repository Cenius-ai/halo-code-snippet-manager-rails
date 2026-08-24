module SnippetsHelper
  LANG_MAP = {
    "ruby"       => "ruby",
    "python"     => "python",
    "javascript" => "javascript",
    "js"         => "javascript",
    "html"       => "html",
    "css"        => "css",
    "sql"        => "sql",
    "bash"       => "shell",
    "shell"      => "shell",
    "json"       => "json",
    "yaml"       => "yaml",
    "yml"        => "yaml",
    "xml"        => "xml",
    "go"         => "go",
    "rust"       => "rust",
    "php"        => "php",
    "java"       => "java",
    "c"          => "c",
    "markdown"   => "markdown",
    "md"         => "markdown",
    "plaintext"  => "plain_text",
    "text"       => "plain_text"
  }.freeze

  LANG_COLORS = {
    "ruby"       => "#CC342D",
    "python"     => "#3572A5",
    "javascript" => "#F7DF1E",
    "html"       => "#E34F26",
    "css"        => "#563D7C",
    "sql"        => "#336791",
    "bash"       => "#4EAA25",
    "json"       => "#292929",
    "yaml"       => "#CB171E",
    "xml"        => "#0060AC",
    "go"         => "#00ADD8",
    "rust"       => "#DEA584",
    "php"        => "#4F5D95",
    "java"       => "#B07219",
    "c"          => "#555555",
    "markdown"   => "#083FA1",
    "plaintext"  => "#6F6056"
  }.freeze

  ALLOWED_TAGS = %w[table tbody tr td pre span].freeze
  ALLOWED_ATTRS = %w[class data-line].freeze

  def render_code(content, language)
    lexer = find_lexer(language)
    formatter = Rouge::Formatters::HTML.new

    lines = content.lines
    output = +%(<table class="highlight-table"><tbody>)

    lines.each_with_index do |line, i|
      line_num = i + 1
      line_content = line.chomp
      highlighted = formatter.format(lexer.lex(line_content))

      output << %(<tr>)
      output << %(<td class="line-number" data-line="#{line_num}">#{line_num}</td>)
      output << %(<td class="line-code"><pre>#{highlighted}</pre></td>)
      output << %(</tr>)
    end

    output << %(</tbody></table>)
    sanitize(output, tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRS)
  rescue => e
    fallback_code(content)
  end

  def language_color(language)
    LANG_COLORS[language&.downcase] || LANG_COLORS["plaintext"]
  end

  private

  def find_lexer(language)
    rouge_lang = LANG_MAP[language&.downcase] || "plain_text"
    Rouge::Lexer.find(rouge_lang) || Rouge::Lexers::PlainText.new
  end

  def fallback_code(content)
    lines = content.lines
    output = +%(<table class="highlight-table"><tbody>)
    lines.each_with_index do |line, i|
      escaped = ERB::Util.html_escape(line.chomp)
      output << %(<tr>)
      output << %(<td class="line-number" data-line="#{i + 1}">#{i + 1}</td>)
      output << %(<td class="line-code"><pre>#{escaped}</pre></td>)
      output << %(</tr>)
    end
    output << %(</tbody></table>)
    sanitize(output, tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRS)
  end
end
