module.exports = (commit, context) => {

  const pattern = /^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)\(BSA-\d+\):\s(.+)/i;
  const match = commit.header.match(pattern);

  if (!match) {
    return null;
  }

  const [, type, description] = match;
  const issueNumber = commit.header.match(/BSA-\d+/)[0];


  const issueUrl = `https://urbi-team.youtrack.cloud/issue/${issueNumber}`;

  return {
    ...commit,
    type,
    scope: `[${issueNumber}](${issueUrl})`,
    subject: description,
  };
};
