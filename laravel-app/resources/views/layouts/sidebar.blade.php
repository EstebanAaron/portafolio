{{-- filepath: c:\laragon\www\portafolio\laravel-app\resources\views\layouts\sidebar.blade.php --}}
<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <a href="{{ url('/') }}" class="brand-link">
        <span class="brand-text font-weight-light">AdminLTE</span>
    </a>
    <div class="sidebar">
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column" role="menu">
                <li class="nav-item">
                    <a href="{{ route('projects.index') }}" class="nav-link">
                        <i class="nav-icon fas fa-th"></i>
                        <p>Proyectos</p>
                    </a>
                </li>
            </ul>
        </nav>
    </div>
</aside>