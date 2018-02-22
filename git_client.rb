require 'uri'
require 'net/http'
require 'pry'
require 'json'

class GitClient
  attr_reader :access_token, :project_name, :repo_name

  def initialize(access_token, project_name, repo_name)
    @access_token = access_token
    @project_name = project_name
    @repo_name = repo_name
  end

  def generate_txt
    open(file_name, 'w') do |f|
      f.write generate_lines
    end
  end

  def generate_lines
    text = ''

    rank.each do |hash|
      line = hash.values.join('; ')
      text += "#{line}\n"
    end

    text
  end

  def rank
    list = []
    get_contributors.each do |contributor|
      hash = contributor.slice('login', 'avatar_url', 'contributions')
      hash.merge!(get_user(contributor['login']).slice('name', 'email'))

      list << hash
    end

    list.sort_by { |l| -l['contributions'] }
  end

  def get_contributors
    uri = URI("https://api.github.com/repos/#{repo_name}/#{project_name}/contributors?access_token=#{access_token}")

    response = Net::HTTP.get(uri)

    JSON.parse response
  end

  def get_user(username)
    uri = URI("https://api.github.com/users/#{username}?access_token=#{access_token}")

    response = Net::HTTP.get(uri)

    JSON.parse response
  end

  private
  def file_name
    "#{project_name}_#{Time.now.strftime('%d-%m-%Y_%H:%M:%S')}"
  end
end

git_client = GitClient.new('c59c8b7972c4f66914c59a6b35f649f64d2e0256', 'braspag-rest', 'Dinda-com-br')
git_client.generate_txt
