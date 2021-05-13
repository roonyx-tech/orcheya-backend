class GitlabStub
  class << self
    def push_event # rubocop:disable MethodLength
      {
        event_name: 'push',
        before: '95790bf891e76fee5e1747ab589903a6a1f80f22',
        after: 'da1560886d4f094c3e6c9ef40349f7d38b5d27d7',
        ref: 'refs/heads/master',
        checkout_sha: 'da1560886d4f094c3e6c9ef40349f7d38b5d27d7',
        user_id: 4,
        user_name: 'John Smith',
        user_email: 'john@example.com',
        user_avatar: 'https://s.gravatar.com/avatar/d4c74594d841139328695756648b6bd6?s=8://s.gravatar.com/avatar/'\
                     'd4c74594d841139328695756648b6bd6?s=80',
        project_id: 15,
        project: {
          name: 'Diaspora',
          description: '',
          web_url: 'http://example.com/mike/diaspora',
          avatar_url: nil,
          git_ssh_url: 'git@example.com:mike/diaspora.git',
          git_http_url: 'http://example.com/mike/diaspora.git',
          namespace: 'Mike',
          visibility_level: 0,
          path_with_namespace: 'mike/diaspora',
          default_branch: 'master',
          homepage: 'http://example.com/mike/diaspora',
          url: 'git@example.com:mike/diaspora.git',
          ssh_url: 'git@example.com:mike/diaspora.git',
          http_url: 'http://example.com/mike/diaspora.git'
        },
        repository: {
          name: 'Diaspora',
          url: 'git@example.com:mike/diaspora.git',
          description: '',
          homepage: 'http://example.com/mike/diaspora',
          git_http_url: 'http://example.com/mike/diaspora.git',
          git_ssh_url: 'git@example.com:mike/diaspora.git',
          visibility_level: 0
        },
        commits: [
          {
            id: 'c5feabde2d8cd023215af4d2ceeb7a64839fc428',
            message: 'Add simple search to projects in public area',
            timestamp: '2013-05-13T18:18:08+00:00',
            url: 'https://dev.gitlab.org/gitlab/gitlabhq/commit/c5feabde2d8cd023215af4d2ceeb7a64839fc428',
            author: {
              name: 'Dmitry Anikin',
              email: 'dmitry.anikin@roonyx.tech'
            }
          }
        ],
        total_commits_count: 1
      }
    end
  end
end
