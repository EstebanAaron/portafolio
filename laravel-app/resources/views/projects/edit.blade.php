{{-- filepath: c:\laragon\www\portafolio\laravel-app\resources\views\projects\edit.blade.php --}}
@extends('layouts.app')

@section('title', 'Editar Proyecto')
@section('header', 'Editar Proyecto')

@section('content')
<div class="card">
    <div class="card-body">
        <form action="{{ route('projects.update', $project) }}" method="POST">
            @csrf
            @method('PUT')
            <div class="form-group">
                <label for="name">Nombre</label>
                <input type="text" name="name" id="name" value="{{ $project->name }}" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="description">Descripción</label>
                <textarea name="description" id="description" class="form-control" rows="4" required>{{ $project->description }}</textarea>
            </div>
            <div class="form-group">
                <label for="url">URL</label>
                <input type="url" name="url" id="url" value="{{ $project->url }}" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-success">Actualizar</button>
        </form>
    </div>
</div>
@endsection
