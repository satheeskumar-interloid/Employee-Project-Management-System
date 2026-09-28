document.addEventListener("turbo:load", () => {
  const projectSelect = document.getElementById("task_project_id");
  const assigneeSelect = document.getElementById("task_assignee_id");

  if (!projectSelect || !assigneeSelect) {
    return;
  }

  function loadProjectMembers() {
    const projectId = projectSelect.value;

    // Save the currently selected assignee BEFORE clearing options
    const selectedAssignee = assigneeSelect.value || assigneeSelect.dataset.selected;

    // Clear existing options
    assigneeSelect.innerHTML = "";

    // Add default option
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

          // Select existing assignee while editing
          if (String(member.id) === String(selectedAssignee)) {
            option.selected = true;
          }

          assigneeSelect.appendChild(option);
        });
      })
      .catch(error => {
        console.error("Error loading project members:", error);
      });
  }

  projectSelect.addEventListener("change", () => {
    // New project selected, so don't preserve old assignee
    assigneeSelect.dataset.selected = "";
    loadProjectMembers();
  });

  loadProjectMembers();
});