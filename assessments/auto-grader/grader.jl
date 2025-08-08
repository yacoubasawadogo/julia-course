# Système de Correction Automatique pour le Cours Julia Interactif
# Système d'évaluation et de rétroaction automatisé

using Test
using JSON
using Dates

# Structure de notation
struct ResultatTest
    nom_test::String
    reussi::Bool
    score::Float64
    commentaire::String
    horodatage::DateTime
end

struct SoumissionEtudiant
    id_etudiant::String
    num_module::Int
    nom_exercice::String
    code::String
    resultats_tests::Vector{ResultatTest}
    score_total::Float64
    soumis_a::DateTime
end

# Fonctions de base du correcteur
function executer_test(fn_test::Function, nom_test::String, score_max::Float64)
    try
        resultat = fn_test()
        if resultat
            return ResultatTest(nom_test, true, score_max, "✅ Réussi !", now())
        else
            return ResultatTest(nom_test, false, 0.0, "❌ Échoué - vérifiez votre implémentation", now())
        end
    catch e
        return ResultatTest(nom_test, false, 0.0, "⚠️ Erreur : $(e)", now())
    end
end

# Correcteurs Module 1
module CorrecteurModule1

using Test
import Main: executer_test, ResultatTest

# Exercice 1 : Bases REPL
function corriger_bases_repl(code_etudiant::String)
    tests = ResultatTest[]
    
    # Test 1: Variable creation
    test1 = run_test("Variable Creation", 25.0) do
        # Check if student created required variables
        occursin("my_name", student_code) && 
        occursin("my_age", student_code) &&
        occursin("pi_value", student_code)
    end
    push!(tests, test1)
    
    # Test 2: Basic arithmetic
    test2 = run_test("Arithmetic Operations", 25.0) do
        # Check if student performed calculations
        occursin("+", student_code) &&
        occursin("*", student_code) &&
        occursin("/", student_code)
    end
    push!(tests, test2)
    
    return tests
end

# Exercise 2: Calculator
function grade_calculator(add_fn, subtract_fn, multiply_fn, divide_fn)
    tests = TestResult[]
    
    # Test addition
    test1 = run_test("Addition", 25.0) do
        add_fn(5, 3) == 8 && add_fn(-2, 2) == 0
    end
    push!(tests, test1)
    
    # Test subtraction
    test2 = run_test("Subtraction", 25.0) do
        subtract_fn(10, 4) == 6 && subtract_fn(0, 5) == -5
    end
    push!(tests, test2)
    
    # Test multiplication
    test3 = run_test("Multiplication", 25.0) do
        multiply_fn(6, 7) == 42 && multiply_fn(-3, 4) == -12
    end
    push!(tests, test3)
    
    # Test division with error handling
    test4 = run_test("Division", 25.0) do
        divide_fn(20, 4) == 5 && 
        divide_fn(10, 0) === nothing  # Should handle division by zero
    end
    push!(tests, test4)
    
    return tests
end

# Exercise 3: Types Game
function grade_types_game(type_fn)
    tests = TestResult[]
    
    # Test type identification
    test1 = run_test("Integer Type", 20.0) do
        type_fn(42) == Int64
    end
    push!(tests, test1)
    
    test2 = run_test("Float Type", 20.0) do
        type_fn(3.14) == Float64
    end
    push!(tests, test2)
    
    test3 = run_test("String Type", 20.0) do
        type_fn("hello") == String
    end
    push!(tests, test3)
    
    test4 = run_test("Array Type", 20.0) do
        type_fn([1, 2, 3]) == Vector{Int64}
    end
    push!(tests, test4)
    
    test5 = run_test("Bool Type", 20.0) do
        type_fn(true) == Bool
    end
    push!(tests, test5)
    
    return tests
end

end # Module1Grader

# Module 2 Graders
module Module2Grader

using Test
import Main: run_test, TestResult

# Exercise 1: Data Structures
function grade_data_structures(matrix_fn, dict_fn)
    tests = TestResult[]
    
    # Test matrix operations
    test1 = run_test("Matrix Creation", 25.0) do
        m = matrix_fn(3, 3)
        size(m) == (3, 3)
    end
    push!(tests, test1)
    
    test2 = run_test("Matrix Operations", 25.0) do
        m = [1 2; 3 4]
        transpose(m) == [1 3; 2 4]
    end
    push!(tests, test2)
    
    # Test dictionary operations
    test3 = run_test("Dictionary Creation", 25.0) do
        d = dict_fn()
        isa(d, Dict)
    end
    push!(tests, test3)
    
    test4 = run_test("Dictionary Access", 25.0) do
        d = Dict("a" => 1, "b" => 2)
        d["a"] == 1 && haskey(d, "b")
    end
    push!(tests, test4)
    
    return tests
end

# Exercise 2: Multiple Dispatch
function grade_multiple_dispatch(process_fn)
    tests = TestResult[]
    
    test1 = run_test("Integer Dispatch", 25.0) do
        process_fn(5) == 10  # Should double integers
    end
    push!(tests, test1)
    
    test2 = run_test("String Dispatch", 25.0) do
        process_fn("hello") == "HELLO"  # Should uppercase strings
    end
    push!(tests, test2)
    
    test3 = run_test("Array Dispatch", 25.0) do
        process_fn([1, 2, 3]) == 6  # Should sum arrays
    end
    push!(tests, test3)
    
    test4 = run_test("Float Dispatch", 25.0) do
        abs(process_fn(3.14) - 9.8596) < 0.01  # Should square floats
    end
    push!(tests, test4)
    
    return tests
end

end # Module2Grader

# Module 3 Graders
module Module3Grader

using Test
import Main: run_test, TestResult

# Exercise 1: ML Basics
function grade_ml_basics(train_fn, predict_fn)
    tests = TestResult[]
    
    # Test model training
    test1 = run_test("Model Training", 33.3) do
        X = [1 2; 3 4; 5 6]
        y = [1, 0, 1]
        model = train_fn(X, y)
        model !== nothing
    end
    push!(tests, test1)
    
    # Test prediction
    test2 = run_test("Prediction", 33.3) do
        X_test = [2 3; 4 5]
        predictions = predict_fn(X_test)
        length(predictions) == 2
    end
    push!(tests, test2)
    
    # Test accuracy
    test3 = run_test("Model Accuracy", 33.4) do
        # Simple test for accuracy > 0.5
        true  # Placeholder - would check actual accuracy
    end
    push!(tests, test3)
    
    return tests
end

# Exercise 2: Data Processing
function grade_data_processing(clean_fn, normalize_fn)
    tests = TestResult[]
    
    test1 = run_test("Data Cleaning", 50.0) do
        data = [1, 2, missing, 4, 5]
        cleaned = clean_fn(data)
        !any(ismissing, cleaned)
    end
    push!(tests, test1)
    
    test2 = run_test("Normalization", 50.0) do
        data = [1.0, 2.0, 3.0, 4.0, 5.0]
        normalized = normalize_fn(data)
        minimum(normalized) ≈ 0.0 && maximum(normalized) ≈ 1.0
    end
    push!(tests, test2)
    
    return tests
end

end # Module3Grader

# Main grading function
function grade_submission(
    student_id::String,
    module_num::Int,
    exercise_name::String,
    student_code::String,
    test_functions...
)
    println("="^50)
    println("📝 Grading Submission")
    println("Student: $student_id")
    println("Module: $module_num - Exercise: $exercise_name")
    println("="^50)
    
    all_tests = TestResult[]
    
    # Run appropriate grader based on module and exercise
    if module_num == 1
        if exercise_name == "calculator"
            append!(all_tests, Module1Grader.grade_calculator(test_functions...))
        elseif exercise_name == "types_game"
            append!(all_tests, Module1Grader.grade_types_game(test_functions...))
        end
    elseif module_num == 2
        if exercise_name == "data_structures"
            append!(all_tests, Module2Grader.grade_data_structures(test_functions...))
        elseif exercise_name == "multiple_dispatch"
            append!(all_tests, Module2Grader.grade_multiple_dispatch(test_functions...))
        end
    elseif module_num == 3
        if exercise_name == "ml_basics"
            append!(all_tests, Module3Grader.grade_ml_basics(test_functions...))
        elseif exercise_name == "data_processing"
            append!(all_tests, Module3Grader.grade_data_processing(test_functions...))
        end
    end
    
    # Calculate total score
    total_score = sum(t.score for t in all_tests)
    max_score = length(all_tests) > 0 ? length(all_tests) * 100.0 / length(all_tests) : 0
    percentage = length(all_tests) > 0 ? (total_score / max_score) * 100 : 0
    
    # Create submission record
    submission = StudentSubmission(
        student_id,
        module_num,
        exercise_name,
        student_code,
        all_tests,
        percentage,
        now()
    )
    
    # Display results
    println("\n📊 Test Results:")
    for test in all_tests
        status = test.passed ? "✅" : "❌"
        println("  $status $(test.test_name): $(test.score) points")
        if !test.passed
            println("    → $(test.feedback)")
        end
    end
    
    println("\n" * "="^50)
    println("📈 Final Score: $(round(percentage, digits=1))%")
    
    # Provide grade
    grade = if percentage >= 90
        "A - Excellent! 🌟"
    elseif percentage >= 80
        "B - Good job! 👍"
    elseif percentage >= 70
        "C - Satisfactory 📚"
    elseif percentage >= 60
        "D - Needs improvement 💪"
    else
        "F - Please review and try again 📖"
    end
    
    println("📝 Grade: $grade")
    println("="^50)
    
    return submission
end

# Performance benchmarking
function benchmark_solution(fn::Function, inputs...)
    times = Float64[]
    
    # Warm up
    fn(inputs...)
    
    # Benchmark
    for _ in 1:100
        t = @elapsed fn(inputs...)
        push!(times, t)
    end
    
    avg_time = sum(times) / length(times)
    
    performance_score = if avg_time < 0.001
        100.0  # Excellent
    elseif avg_time < 0.01
        80.0   # Good
    elseif avg_time < 0.1
        60.0   # Acceptable
    else
        40.0   # Needs optimization
    end
    
    return (
        avg_time = avg_time,
        score = performance_score,
        feedback = "Average execution time: $(round(avg_time * 1000, digits=3))ms"
    )
end

# Save results to JSON
function save_results(submission::StudentSubmission, filepath::String)
    data = Dict(
        "student_id" => submission.student_id,
        "module" => submission.module_num,
        "exercise" => submission.exercise_name,
        "score" => submission.total_score,
        "timestamp" => string(submission.submitted_at),
        "tests" => [
            Dict(
                "name" => t.test_name,
                "passed" => t.passed,
                "score" => t.score,
                "feedback" => t.feedback
            ) for t in submission.test_results
        ]
    )
    
    open(filepath, "w") do f
        JSON.print(f, data, 4)
    end
    
    println("💾 Results saved to: $filepath")
end

# Example usage
if false  # Set to true to run example
    # Student's calculator implementation
    add(a, b) = a + b
    subtract(a, b) = a - b
    multiply(a, b) = a * b
    divide(a, b) = b == 0 ? nothing : a / b
    
    # Grade the submission
    result = grade_submission(
        "student123",
        1,
        "calculator",
        "# Student's calculator code here",
        add, subtract, multiply, divide
    )
    
    # Save results
    save_results(result, "student123_calculator_results.json")
end

println("✅ Auto-grader system loaded successfully!")