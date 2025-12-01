export function Sidebar(){
    const mobileMenuBtn = document.getElementById('mobile-menu-btn');
    const mobileCloseBtn = document.getElementById('mobile-close-btn');
    const mobileMenu = document.getElementById('mobile-menu');

    mobileMenuBtn.addEventListener('click', () => {
        mobileMenu.classList.remove('-translate-x-full');
        mobileMenu.classList.add('translate-x-0');

        mobileMenuBtn.classList.add('hidden');
        mobileCloseBtn.classList.remove('hidden');
    });

    mobileCloseBtn.addEventListener('click', () => {
        mobileMenu.classList.add('-translate-x-full');
        mobileMenu.classList.remove('translate-x-0');

        mobileCloseBtn.classList.add('hidden');
        mobileMenuBtn.classList.remove('hidden');
    });
}