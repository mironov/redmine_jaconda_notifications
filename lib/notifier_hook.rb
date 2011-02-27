class NotifierHook < Redmine::Hook::Listener

  def controller_issues_new_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    issue = context[:issue]

    text = "<i>#{CGI::escapeHTML("#{issue.author.name}")} created issue <a href=\"#{redmine_url}/issues/#{issue.id}\" target=\"_blank\">##{issue.id} #{CGI::escapeHTML(issue.subject)}</a></i>"
    text += "<br />→ Tracker: <b>#{CGI::escapeHTML(issue.tracker.name)}</b>"
    text += "<br />→ Priority: <b>#{CGI::escapeHTML(issue.priority.name)}</b>"
    if issue.assigned_to
      text += "<br />→ Assigned to: <b>#{CGI::escapeHTML(issue.assigned_to.name)}</b>"
    end
    if issue.start_date
      text += "<br />→ Start: <b>#{CGI::escapeHTML(issue.start_date.strftime("%e %B %Y"))}</b>"
    end
    if issue.due_date
      text += "<br />→ Due: <b>#{CGI::escapeHTML(issue.due_date.strftime("%e %B %Y"))}</b>"
    end
    if issue.estimated_hours
      text += "<br />→ Estimated time: <b>#{CGI::escapeHTML(issue.estimated_hours)} hours</b>"
    end
    if issue.done_ratio
      text += "<br />→ Done: <b>#{issue.done_ratio} %</b>"
    end
    text += "<br /><br />#{truncate_words(issue.description)}"

    deliver text
  end

  def controller_issues_edit_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    issue = context[:issue]
    journal = context[:journal]

    text = "<i>#{CGI::escapeHTML("#{journal.user.name}")} updated issue <a href=\"#{redmine_url}/issues/#{issue.id}\" target=\"_blank\">##{issue.id} #{CGI::escapeHTML(issue.subject)}</a></i>"
    text += "<br />→ Tracker: <b>#{CGI::escapeHTML(issue.tracker.name)}</b>"
    text += "<br />→ Priority: <b>#{CGI::escapeHTML(issue.priority.name)}</b>"
    if issue.assigned_to
      text += "<br />→ Assigned to: <b>#{CGI::escapeHTML(issue.assigned_to.name)}</b>"
    end
    if issue.start_date
      text += "<br />→ Start: <b>#{CGI::escapeHTML(issue.start_date.strftime("%e %B %Y"))}</b>"
    end
    if issue.due_date
      text += "<br />→ Due: <b>#{CGI::escapeHTML(issue.due_date.strftime("%e %B %Y"))}</b>"
    end
    if issue.estimated_hours
      text += "<br />→ Estimated time: <b>#{CGI::escapeHTML(issue.estimated_hours)} hours</b>"
    end
    if issue.done_ratio
      text += "<br />→ Done: <b>#{issue.done_ratio} %</b>"
    end
    text += "<br /><br />#{truncate_words(journal.notes)}"

    deliver text
end

  def controller_messages_new_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    message = context[:message]

    text = "<i>#{CGI::escapeHTML("#{message.author.name}")} posted message <a href=\"#{redmine_url}/boards/#{message.board.id}/topics/#{message.root.id}#message-#{message.id}\" target=\"_blank\">#{CGI::escapeHTML(message.subject)}</a></i>"
    text += "<br /><br />#{truncate_words(message.content)}"

    deliver text
  end

  def controller_messages_reply_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    message = context[:message]

    text = "<i>#{CGI::escapeHTML("#{message.author.name}")} commented message <a href=\"#{redmine_url}/boards/#{message.board.id}/topics/#{message.root.id}#message-#{message.id}\" target=\"_blank\">#{CGI::escapeHTML(message.subject)}</a></i>"
    text += "<br /><br />#{truncate_words(message.content)}"

    deliver text
  end

  def controller_wiki_edit_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    page = context[:page]

    text = "<i>#{CGI::escapeHTML("#{page.content.author.name}")} edited wiki <a href=\"#{redmine_url}/projects/#{project.identifier}/wiki/#{page.title}\" target=\"_blank\">#{CGI::escapeHTML(page.pretty_title)}</a></i>"

    deliver text
  end

private

  def deliver(message)
    Jaconda::Notification.authenticate(Setting.plugin_redmine_jaconda_notifications)

    Jaconda::Notification.notify(:text => message,
                                :sender_name => "redmine")
  end

  def truncate_words(text, length = 40, end_string = '…')
    return if text == nil
    words = CGI::escapeHTML(text).gsub(/\r?\n/, '<br />').split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
