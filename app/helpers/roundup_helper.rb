module RoundupHelper
  def monitored_accounts_placeholder
    <<-TEXT.strip_heredoc
    @rbrampage
    @newsycombinator
    @iamdevloper
    @horse_js
    TEXT
  end

  def roundup_frequencies(roundup)
    [['Daily', 0], ['Weekly', 1]].sort_by do |label, value|
      (value - roundup.frequency).abs
    end
  end
end
