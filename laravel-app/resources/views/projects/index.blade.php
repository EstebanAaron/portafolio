{{-- filepath: c:\laragon\www\portafolio\laravel-app\resources\views\projects\index.blade.php --}}
@extends('layouts.app')

@section('title', 'Listado de Proyectos')
@section('header', 'Proyectos')

@section('content')
<div class="card">
    <div class="card-header">
        <a href="{{ route('projects.create') }}" class="btn btn-primary">Crear Proyecto</a>
    </div>
    <div class="card-body">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>URL</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($projects as $project)
                    <tr>
                        <td>{{ $project->id }}</td>
                        <td>{{ $project->name }}</td>
                        <td>{{ $project->description }}</td>
                        <td><a href="{{ $project->url }}" target="_blank">Abrir</a></td>
                        <td>
                            <a href="{{ route('projects.edit', $project) }}" class="btn btn-warning btn-sm">Editar</a>
                            <form action="{{ route('projects.destroy', $project) }}" method="POST" style="display:inline-block;">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-danger btn-sm">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>
    </div>
</div>
@endsection