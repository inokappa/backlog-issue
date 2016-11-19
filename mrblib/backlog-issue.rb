def __main__(argv)

  opts = Getopts.getopts(
    'vh',
    'version',
    'help',
    'space:',
    'project:',
    'title:',
    'type:',
    'status:',
    'priority:',
    'desc:',
    'key:',
    'comment:'
  )

  # puts opts

  if opts['v'] || opts['version']
    puts "v#{BacklogIssue::VERSION}"
  elsif opts['space'] == ''
    puts 'Please set Backlog Space Name.'
  elsif ENV['BACKLOG_API_KEY'] == ''
    puts 'Please set Backlog API Key.'
  elsif opts['h'] || opts['help']
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._help
  elsif opts['title'] != '' && opts['type'] != '' && opts['priority'] != ''
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._create
  elsif opts['key'] != '' && opts['priority'] != ''
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._status
  elsif opts['key'] != '' && opts['status'] != ''
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._status
  elsif opts['key'] != '' && opts['comment'] != ''
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._comment
  else
    issue = BacklogIssue::BacklogIssue.new(opts)
    issue._help
  end

end
