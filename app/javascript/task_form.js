import { DirectUpload } from "@rails/activestorage"
// =====================================================
// PROJECT → ASSIGNEE
// Keep your existing functionality unchanged
// =====================================================

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
      })
      .catch(error => {
        console.error( "Error loading project members:", error );
      });
  }

  projectSelect.addEventListener( "change", loadProjectMembers );
}
// =====================================================
// ATTACHMENTS
// Separate functionality
// =====================================================
function initTaskAttachments() {
  const fileInput = document.getElementById("task_attachments");
  const form = document.getElementById("task-form");
  const pendingAttachments = document.getElementById("pending-attachments");
  if (!fileInput || !form || !pendingAttachments) {
    return;
  }
  if (fileInput.dataset.bound === "true") {
    return;
  }
  fileInput.dataset.bound = "true";
  fileInput.addEventListener("change", () => {
    const files = Array.from(fileInput.files);
    files.forEach(file => {
      uploadAttachment(file);
    });
    // Clear browser file input.
    // The uploaded file is represented by its signed_id.
    fileInput.value = "";
  });

  pendingAttachments.addEventListener("click", (event) => {
    const removeButton = event.target.closest(".remove-attachment");
    if (!removeButton) return;
    const wrapper = removeButton.closest(".pending-attachment");
    if (!wrapper) return;
    const signedId = wrapper.dataset.signedId;
    // Find hidden signed_id field
    const hiddenField = form.querySelector( `input[data-attachment-id="${CSS.escape(signedId)}"]` );
    if (hiddenField) {
      hiddenField.remove();
    }
    // Remove attachment from UI
    wrapper.remove();
  });

  function uploadAttachment(file) {
    const upload = new DirectUpload( file, fileInput.dataset.directUploadUrl );
    upload.create((error, blob) => {
      if (error) {
        console.error( "Attachment upload failed:", error );
        return;
      }
      addAttachmentHiddenField(blob);
      displayPendingAttachment(blob);
    });
  }

  function addAttachmentHiddenField(blob) {
    const hiddenField = document.createElement("input");
    hiddenField.type = "hidden";
    hiddenField.name = "task[attachments][]";
    hiddenField.value = blob.signed_id;
    hiddenField.dataset.attachmentId = blob.signed_id;
    form.appendChild(hiddenField);
  }
  
  function displayPendingAttachment(blob) {
    const wrapper = document.createElement("div");
    wrapper.classList.add( "pending-attachment" );
    wrapper.dataset.signedId = blob.signed_id;
    wrapper.innerHTML = `
      <span> 📎 ${blob.filename} </span>
      <button type="button" class="remove-attachment"> X </button>
    `;
    pendingAttachments.appendChild(wrapper);
  }
}
// =====================================================
// INITIALIZE BOTH
// =====================================================
document.addEventListener(
  "turbo:load",
  () => {
    initTaskForm();
    initTaskAttachments();
  }
);

document.addEventListener(
  "turbo:render",
  () => {
    initTaskForm();
    initTaskAttachments();
  }
);