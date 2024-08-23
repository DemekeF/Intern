<?php

namespace App\Http\Controllers;

use App\Models\Employee;
use Illuminate\Http\Request;

class EmployeeController extends Controller
{
    // Display a listing of employees
    public function index()
    {
        return response()->json(Employee::all());
    }

    // Store a newly created employee in storage
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'gender' => 'required|string|max:10',
            'age' => 'required|integer|min:18',
            'salary' => 'required|numeric|min:0',
        ]);

        $employee = Employee::create($request->all());

        return response()->json($employee, 201);
    }

    // Display the specified employee
    public function show(Employee $employee)
    {
        return response()->json($employee);
    }

    // Update the specified employee in storage
    public function update(Request $request, Employee $employee)
    {
        $request->validate([
            'name' => 'sometimes|string|max:255',
            'gender' => 'sometimes|string|max:10',
            'age' => 'sometimes|integer|min:18',
            'salary' => 'sometimes|numeric|min:0',
        ]);

        $employee->update($request->all());

        return response()->json($employee);
    }

    // Remove the specified employee from storage
    public function destroy(Employee $employee)
    {
        $employee->delete();

        return response()->json(null, 204);
    }
}
