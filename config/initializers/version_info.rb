# frozen_string_literal: true
# loads the version info if available from the Rails root, used in deployments

version_info_file = Rails.root.join('mk2.vi')
if version_info_file.exist?
  type, version, commit = File.readlines(version_info_file).to_a
  Rails.configuration.version_info = {
    type: type,
    version: version,
    commit: commit
  }
else
  Rails.configuration.version_info = nil
end
