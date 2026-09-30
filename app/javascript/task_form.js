function initTaskForm() {
  const projectSelect = document.getElementById("task_project_id");
  const assigneeSelect = document.getElementById("task_assignee_id");
  if (!projectSelect || !assigneeSelect) return;
  if (projectSelect.dataset.bound === "true") return; 
  projectSelect.dataset.bound = "true";
  function resetAssignees() {
    assigneeSelect.innerHTML = "";
    const defaultOption = document.createElement("option");
    defaultOption.value = "";
    defaultOption.textContent = "Select Assignee";
    assigneeSelect.appendChild(defaultOption);
  }
  function loadProjectMembers() {
    const projectId = projectSelect.value;
    resetAssignees();
    if (!projectId) return;
    fetch(`/projects/${projectId}/members`, {
      headers: { Accept: "application/json" }
    })
      .then(response => {
        if (!response.ok) throw new Error("Failed to load project members");
        return response.json();
      })
      .then(members => {
        members.forEach(member => {
          const option = document.createElement("option");
          option.value = member.id;
          option.textContent = member.name;
          assigneeSelect.appendChild(option);
        });
      })
      .catch(error => console.error("Error loading project members:", error));
  }
  projectSelect.addEventListener("change", loadProjectMembers);
}
document.addEventListener("turbo:load", initTaskForm);
document.addEventListener("turbo:render", initTaskForm);