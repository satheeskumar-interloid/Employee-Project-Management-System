document.addEventListener("turbo:load", () => {
    const projectSelect = document.getElementById("task_project_id");
    const assigneeSelect = document.getElementById("task_assignee_id");

if (!projectSelect || !assigneeSelect) {
    return;
  }

  function loadProjectMembers() {
    const projectId = projectSelect.value;

    assigneeSelect.innerHTML = "";

    const defaultOption = document.createElement("option");

    defaultOption.value = "";
    defaultOption.textContent = "Select Assignee";

    assigneeSelect.appendChild(defaultOption);

    if (!projectId) {
      return;
    }

    fetch(`/projects/${projectId}/members`)
      .then(response => {
        if (!response.ok) {
          throw new Error("Failed to load project members");
        }

        return response.json();
      })
      .then(members => {

        members.forEach(member => {

          const option = document.createElement("option");

          option.value = member.id;
          option.textContent = member.name;

          assigneeSelect.appendChild(option);
        });

        // Keep selected assignee when editing
        const selectedAssignee =
          assigneeSelect.dataset.selected;

        if (selectedAssignee) {
          assigneeSelect.value = selectedAssignee;
        }

      })
      .catch(error => {
        console.error(error);
      });
  }

  projectSelect.addEventListener(
    "change",
    loadProjectMembers
  );

  loadProjectMembers();
});