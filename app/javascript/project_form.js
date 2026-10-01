import { DirectUpload } from "@rails/activestorage";

function initProjectAttachments() {
    const fileInput = document.getElementById("project_attachments");
    const form = document.getElementById("project-form");
    const pendingAttachments = document.getElementById( "pending-project-attachments" );
    if ( !fileInput || !form || !pendingAttachments ) {
        return;
    }
    if (fileInput.dataset.bound === "true") {
        return;
    }
    fileInput.dataset.bound = "true";

    // SELECT NEW FILES

    fileInput.addEventListener("change", () => {
        const files = Array.from(fileInput.files);
        files.forEach(file => { uploadAttachment(file); });
        // Clear native file input.
        // The file is now represented by signed_id.
        fileInput.value = "";
    });
  // ==========================================
  // REMOVE ATTACHMENT
  // Works for:
  // - Newly uploaded attachments
  // - Attachments restored after validation
  // ==========================================
    pendingAttachments.addEventListener(
        "click",
        event => {
        const removeButton = event.target.closest( ".remove-project-attachment" );
        if (!removeButton) return;
        const wrapper = removeButton.closest( ".pending-attachment" );
        if (!wrapper) return;
        const signedId = wrapper.dataset.signedId;
        const hiddenField = form.querySelector( `input[data-attachment-id="${CSS.escape(signedId)}"]` );
        if (hiddenField) {
            hiddenField.remove();
        }
        wrapper.remove();
        }
    );
  // ==========================================
  // DIRECT UPLOAD
  // ==========================================
    function uploadAttachment(file) {
        const upload = new DirectUpload( file, fileInput.dataset.directUploadUrl );
        upload.create((error, blob) => {
        if (error) {
            console.error( "Project attachment upload failed:", error );
            return;
        }
        addHiddenField(blob);
        displayAttachment(blob);
        });
    }
  // ==========================================
  // SIGNED ID
  // ==========================================
    function addHiddenField(blob) {
        const hiddenField = document.createElement("input");
        hiddenField.type = "hidden";
        hiddenField.name = "project[attachments][]";
        hiddenField.value = blob.signed_id;
        hiddenField.dataset.attachmentId = blob.signed_id;
        form.appendChild(hiddenField);
    }
  // ==========================================
  // DISPLAY ATTACHMENT
  // ==========================================
    function displayAttachment(blob) {
        const wrapper = document.createElement("div");
        wrapper.classList.add( "pending-attachment" );
        wrapper.dataset.signedId = blob.signed_id;

        wrapper.innerHTML = ` <span> 📎 ${blob.filename} </span> <button type="button" class="remove-project-attachment"> X </button> `;
        pendingAttachments.appendChild( wrapper );
    }
}
document.addEventListener( "turbo:load", initProjectAttachments );
document.addEventListener( "turbo:render", initProjectAttachments );