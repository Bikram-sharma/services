export function Mailto() {
    document.getElementById("contact-form").addEventListener("submit", function (e) {
        e.preventDefault();
    
        const name = document.getElementById("name").value;
        const email = document.getElementById("email").value;
        const phone = document.getElementById("phone").value;
        const company = document.getElementById("company").value;
        const subject = document.getElementById("subject").value;
        const message = document.getElementById("message").value;
    
        const receiver = "dawadorji295@gmail.com"; // <- CHANGE THIS
    
        const subj = encodeURIComponent(subject);
        const body = encodeURIComponent(
            "Name: " + name + "\n" +
            "Email: " + email + "\n" +
            "Phone: " + phone + "\n" +
            "Company: " + company + "\n\n" +
            "Message:\n" + message
        );
    
        // Open user's default email app
        window.location.href = `mailto:${receiver}?subject=${subj}&body=${body}`;
    });
}