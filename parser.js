module.exports = (commit, context) => {
  // Проверяем, что commit существует и не равен null
  if (!commit) {
    return null;
  }

  // Проверяем, что commit.header существует
  if (!commit.header) {
    return null;
  }

  // Регулярное выражение для нового формата коммитов
  const pattern = /^(feat|fix|docs|style|refactor|test|chore):\s*:[\w-]+:\s*(BALADY-\d+):\s*(.+)/i;
  const match = commit.header.match(pattern);

  // Если коммит не соответствует формату, пропускаем его
  if (!match) {
    return null;
  }

  // Извлекаем тип, номер задачи и описание
  const [, type, , issueNumber, description] = match;

  // Формируем ссылку на задачу
  const issueUrl = `https://urbi-team.youtrack.cloud/issue/${issueNumber}`;

  // Возвращаем структурированный коммит
  return {
    ...commit,
    type, // Тип коммита (feat, fix и т.д.)
    scope: issueNumber, // Номер задачи
    subject: `[${issueNumber}](${issueUrl}): ${description}`, // Описание коммита с ссылкой
  };
};