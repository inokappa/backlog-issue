module BacklogIssue
  class BacklogIssue

    def initialize(opts = {})
      @api_key = ENV['BACKLOG_API_KEY']
      @space = opts['space']
      @project = opts['project']
      @issue = opts['title']
      @issue_type = opts['type']
      @issue_priority = opts['priority']
      @issue_status = opts['status']
      @issue_start = opts['start']
      @issue_due = opts['due']
      @issue_desc = opts['desc']
      @issue_key = opts['key']
      @comment = opts['comment']
    end

    def _list
    end

    def _create

      unless @issue_start == ''
        issue_start = get_today
      else
        issue_start = @issue_start
      end

      project_id = get_project_id

      uri = backlog_endpoint + '/issues' + '?apiKey=' + @api_key
      response = http_request.post(
        uri,
        { 
          "projectId" => project_id,
          "summary" => @issue,
          "issueTypeId" => @issue_type,
          "description" => @issue_desc,
          "priorityId" => @issue_priority,
          "startDate" => issue_start,
          "dueDate" => @issue_due
        },
        { "Content-Type" => "application/x-www-form-urlencoded" }
      )
      puts response.body

    end

    def _status

      unless @comment == ''
        _comment
      end

      uri = backlog_endpoint + '/issues/' + @issue_key + '?apiKey=' + @api_key
      response = http_request.patch(
        uri,
        { 
          "priorityId" => @issue_priority,
          "statusId" => @issue_status,
          "dueDate" => @issue_due
        },
        { "Content-Type" => "application/x-www-form-urlencoded" }
      )
      puts response.body
    end

    def _comment
      uri = backlog_endpoint + '/issues/' + @issue_key + '/comments?apiKey=' + @api_key
      response = http_request.post(
        uri,
        { "content" => @comment },
        { "Content-Type" => "application/x-www-form-urlencoded" }
      )
      puts response.body
    end

    def _help
      if @project == '' then
        project_id = ''  
        issue_type = ''  
      else
        project_id = get_project_id
        issue_type = get_issue_type
      end

      help = <<-EOT

Usage: backlog-issue [options]

  -h, --help               Display help.
  -v, --version            Display version.
  --space Space_Name       Set Backlog Space Name(Required).
  --project Project_Key    Set Project Key(Project ID = #{project_id}).
  --issue Issue_Title      Set Issue Title.
  --type Issue_Type        Set Issue Type(Issue Type ID = #{issue_type}).
  --status Status_ID       Set Issue Status ID( 未対応 = 1, 処理中 = 2, 処理済み = 3, 完了 = 4,).
  --start StartDate        Set Issue Start Date(Format example: 2016-11-21).
  --due DueDate            Set Issue Due Date(Format example: 2016-11-23).
  --priority Priority_ID   Set Issue Priority ID( 高 = 2, 中 = 3, 低 = 4,).
  --desc Description       Set Issue Description.
  --key Issue_Key_Name     Set Issue Key Name.
  --comment Comment        Set Comment.
      EOT

      puts help
    end

    private

    def http_request
      HttpRequest.new()
    end

    def backlog_endpoint
      'https://' + @space + '.backlog.jp' + '/api/v2'
    end

    def get_today
      Time.now.strftime("%Y-%m-%d")
    end

    def get_issue_type
      uri = backlog_endpoint + '/projects/' + @project + '/issueTypes?apiKey=' + @api_key
      response = http_request.get(uri)
      issue_type = ''
      JSON::parse(response.body).each do |h|
         issue_type << ' ' + h['name'] + ' = ' + h['id'].to_s + ',' 
      end

      return issue_type
    end

    def get_project_id
      uri = backlog_endpoint + '/projects/' + @project + '?apiKey=' + @api_key
      response = http_request.get(uri)
      project_id = JSON::parse(response.body)['id']

      return project_id
    end
  
  end
end
