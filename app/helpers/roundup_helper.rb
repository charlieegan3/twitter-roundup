module RoundupHelper
  def monitored_accounts_placeholder
    <<-TEXT.strip_heredoc
    @rbrampage
    @newsycombinator
    @iamdevloper
    @horse_js
    TEXT
  end

  def roundup_frequencies
    [['Daily', 0], ['Weekly', 1]]
  end
end
