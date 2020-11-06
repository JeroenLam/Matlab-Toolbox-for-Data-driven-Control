classdef testDataInputTest < matlab.unittest.TestCase
%TESTDATAINPUTTEST Unit testing for testDataInput(A, B)
%   This file contains all unit test used to verify the implementation is
%   working as expected. The test can be run using:
%     result = run(testDataInputTest)
%   The unit test are implemented using matlab.unittest.TestCase

    % Unit tests for the testDataInput(A) function
    methods (Test)
        function testEmptyA(testCase)
            % Test empty A
            A = [];
            errorId = 'testDataInput:EmptyStateData';
            testCase.verifyError(@() testDataInput(A), errorId);
        end
        
        function testScalerA(testCase)
            % Test scaler A
            A = 9;
            [act_Xmin, act_Xplus, act_n, act_Umin, act_m] = testDataInput(A);
            exp_Xmin  = zeros(1,0);
            exp_Xplus = zeros(1,0);
            exp_n     = 1;
            exp_Umin  = [];
            exp_m     = 0;
            testCase.verifyEqual(act_Xmin,  exp_Xmin);
            testCase.verifyEqual(act_Xplus, exp_Xplus);
            testCase.verifyEqual(act_n,     exp_n);
            testCase.verifyEqual(act_Umin,  exp_Umin);
            testCase.verifyEqual(act_m,     exp_m);
        end
        
        function testRowA(testCase)
            % Test row vector A
            A = [1 2 3];
            [act_Xmin, act_Xplus, act_n, act_Umin, act_m] = testDataInput(A);
            exp_Xmin  = [1 2];
            exp_Xplus = [2 3];
            exp_n     = 1;
            exp_Umin  = [];
            exp_m     = 0;
            testCase.verifyEqual(act_Xmin,  exp_Xmin);
            testCase.verifyEqual(act_Xplus, exp_Xplus);
            testCase.verifyEqual(act_n,     exp_n);
            testCase.verifyEqual(act_Umin,  exp_Umin);
            testCase.verifyEqual(act_m,     exp_m);
        end
        
        function testColA(testCase)
            % Test column vector A
            A = [1 ; 2 ; 3];
            [act_Xmin, act_Xplus, act_n, act_Umin, act_m] = testDataInput(A);
            exp_Xmin  = zeros(3,0);
            exp_Xplus = zeros(3,0);
            exp_n     = 3;
            exp_Umin  = [];
            exp_m     = 0;
            testCase.verifyEqual(act_Xmin,  exp_Xmin);
            testCase.verifyEqual(act_Xplus, exp_Xplus);
            testCase.verifyEqual(act_n,     exp_n);
            testCase.verifyEqual(act_Umin,  exp_Umin);
            testCase.verifyEqual(act_m,     exp_m);
        end
        
        function testMatrixA(testCase)
            % Test matric A
            A = [1 0 2 ; 2 9 0];
            [act_Xmin, act_Xplus, act_n, act_Umin, act_m] = testDataInput(A);
            exp_Xmin  = [1 0 ; 2 9];
            exp_Xplus = [0 2 ; 9 0];
            exp_n     = 2;
            exp_Umin  = [];
            exp_m     = 0;
            testCase.verifyEqual(act_Xmin,  exp_Xmin);
            testCase.verifyEqual(act_Xplus, exp_Xplus);
            testCase.verifyEqual(act_n,     exp_n);
            testCase.verifyEqual(act_Umin,  exp_Umin);
            testCase.verifyEqual(act_m,     exp_m);
        end
        
        function testNonNummericA(testCase)
            % Test non numeric input A
            A = 'not a matrix';
            errorId = 'testDataInput:NonNumericArgument';
            testCase.verifyError(@() testDataInput(A), errorId);
        end
        
    end
    
    % Unit tests for the testDataInput(A, B) function
    methods (Test)
        function testNonNummericB(testCase)
            % Test non numeric input (and reverse)
            A = [];
            B = 'not a matrix';
            errorId = 'testDataInput:NonNumericArgument';
            testCase.verifyError(@() testDataInput(A,B), errorId);
            testCase.verifyError(@() testDataInput(B,A), errorId);
        end
        
        function testIncorrectDimensions(testCase)
            % Test a few cases where X and U are not the correct size (and reverse)
            A = ones(4,6);
            for i = [1:4 6 8:10]
                B = ones(2,i);
                errorId = 'testDataInput:InconsistentLengthData';
                testCase.verifyError(@() testDataInput(A,B), errorId);
                testCase.verifyError(@() testDataInput(B,A), errorId);
            end
        end
                
        function testEmptyAndNonEmpty(testCase)
            % Test A empty and B non-empty (and reverse)
            A = ones(3,7);
            B = [];
            testCase.verifyEqual(testDataInput(A), testDataInput(A,B));
            testCase.verifyEqual(testDataInput(A), testDataInput(B,A));
        end
        
        function testEmptyAB(testCase)
            % Test empty A and B
            A = [];
            errorId = 'testDataInput:EmptyStateData';
            testCase.verifyError(@() testDataInput(A,A), errorId);
        end
        
        function testValidData(testCase)
            % Test valid data (and reverse)
            A = ones(4,6);
            B = zeros(2,5);
            [act_Xmin, act_Xplus, act_n, act_Umin, act_m] = testDataInput(A,B);
            exp_Xmin  = ones(4,5);
            exp_Xplus = ones(4,5);
            exp_n     = 4;
            exp_Umin  = B;
            exp_m     = 2;
            testCase.verifyEqual(act_Xmin,  exp_Xmin);
            testCase.verifyEqual(act_Xplus, exp_Xplus);
            testCase.verifyEqual(act_n,     exp_n);
            testCase.verifyEqual(act_Umin,  exp_Umin);
            testCase.verifyEqual(act_m,     exp_m);
            testCase.verifyEqual(testDataInput(B,A), testDataInput(A,B));
        end
    end    
end

