class NotifierHook < Redmine::Hook::Listener

  def controller_issues_new_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    issue = context[:issue]
    user = issue.author
    deliver "#{user.firstname} created issue “#{issue.subject}”. Comment: “#{truncate_words(issue.description)}” #{redmine_url}/issues/#{issue.id}"
  end
  
  def controller_issues_edit_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    issue = context[:issue]
    journal = context[:journal]
    user = journal.user
    deliver "#{user.firstname} edited issue “#{issue.subject}”. Comment: “#{truncate_words(journal.notes)}”. #{redmine_url}/issues/#{issue.id}"
  end

  def controller_messages_new_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    message = context[:message]
    user = message.author
    deliver "#{user.firstname} wrote a new message “#{message.subject}” on #{project.name}: “#{truncate_words(message.content)}”. #{redmine_url}/boards/#{message.board.id}/topics/#{message.root.id}#message-#{message.id}"
  end
  
  def controller_messages_reply_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    message = context[:message]
    user = message.author
    deliver "#{user.firstname} replied a message “#{message.subject}” on #{project.name}: “#{truncate_words(message.content)}”. #{redmine_url}/boards/#{message.board.id}/topics/#{message.root.id}#message-#{message.id}"
  end
  
  def controller_wiki_edit_after_save(context = { })
    redmine_url = "#{Setting[:protocol]}://#{Setting[:host_name]}"
    project = context[:project]
    page = context[:page]
    user = page.content.author
    deliver "#{user.firstname} edited the wiki “#{page.pretty_title}” on #{project.name}. #{redmine_url}/projects/#{project.identifier}/wiki/#{page.title}"
  end

private
  def deliver(message)
    Jaconda::API.authenticate(Setting.plugin_redmine_jaconda_notifications[:api_token])
    Jaconda::Message.create(:room_id => Setting.plugin_redmine_jaconda_notifications[:room_id], :text => message)
  end

  def truncate_words(text, length = 20, end_string = '…')
    return if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end
end
