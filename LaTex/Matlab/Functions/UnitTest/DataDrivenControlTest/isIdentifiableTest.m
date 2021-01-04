classdef isIdentifiableTest < matlab.unittest.TestCase
%ISIDENTIFIABLETEST Unit testing for isIdentifiable(X,U)
%   This file contains all unit test used to verify the implementation is
%   working as expected. The test can be run using:
%     result = run(isIdentifiableTest)
%   The unit test are implemented using matlab.unittest.TestCase
    
    % Unit tests for the isIdentifiable(X) function
    methods (Test)
        function testZeroX(testCase)
            % Test for zero matrix
            X = [0 0 ; 0 0];
            testVerifyNotInformative(testCase, X);
        end
        
        function testToLittleData(testCase)
            % Test fewer samples than states
            X = [1 0 ; 0 0];
            testVerifyNotInformative(testCase, X);
        end

        function testFullRankX(testCase)
            % Test for full rank Xmin
            X = [1 0 0 ; 0 1 0];
            exp_A = [0 0;1 0];
            exp_B = zeros(2,0);
            testVerifyInformative(testCase, exp_A, exp_B, X);
        end
        
        function testNotFullRankX(testCase)
            % Test for non-full rank Xmin
            X = [1 0 0 ; 1 0 0];
            testVerifyNotInformative(testCase, X);
        end
        
        function testEmptyX(testCase)
            % Test for empty X
            X = [];
            testVerifyError(testCase, 'testDataInput:EmptyStateData', X);
        end
        
        function testNonNummericX(testCase)
            % Test non numeric input X 
            X = 'not a matrix';
            testVerifyError(testCase, 'testDataInput:NonNumericArgument', X);
        end
    end
    
    % Unit tests for the isIdentifiable(X,U) function
    methods (Test)
        function testZeroData(testCase)
            % Test for constant zero data
            X = [0 0 ; 0 0];
            U = 0;
            testVerifyNotInformative(testCase, X, U);
        end

        function testInitialCondition(testCase)
            % Test for only initial conditions
            testVerifyNotInformative(testCase, 1, []);
        end

        function testInvalidDataSize(testCase)
            % Test for invalid data size
            X = 0;
            U = [0 0 0 0 0];
            testVerifyError(testCase, 'testDataInput:InconsistentLengthData', X, U);
            testVerifyError(testCase, 'testDataInput:InconsistentLengthData', U, X);
        end

        function testSystem1(testCase)
            % Test a combination of X and U with possible dependance
            X_full      = [1 0 0 0 0; 0 1 0 0 0; 0 0 1 0 0];
            X_notFull   = [1 0 0 0 0; 0 1 0 0 0; 0 0 0 0 0];
            U_0         = [0 0 0 0];
            U_linDep    = [0 1 0 0];
            U_linInd    = [0 0 0 1];
            exp_A       = [0 0 0;1 0 0;0 1 0];
            exp_b       = [0;0;0];
            testVerifyNotInformative(testCase, X_full, U_0);
            testVerifyNotInformative(testCase, X_full, U_linDep);
            testVerifyInformative(testCase, exp_A, exp_b, X_full, U_linInd);
            testVerifyNotInformative(testCase, X_notFull, U_0);
            testVerifyNotInformative(testCase, X_notFull, U_linDep);
            testVerifyNotInformative(testCase, X_notFull, U_linInd);
        end
        
        function testNonNummericXU(testCase)
            % Test non numeric input X 
            A = 'not a matrix';
            B = [];
            testVerifyError(testCase, 'testDataInput:NonNumericArgument', A, B);
            testVerifyError(testCase, 'testDataInput:NonNumericArgument', B, A);
        end
    end
    
    % Abstract test methods used to improve readability
    methods
        function testVerifyError(testCase, errorId, X, U)
            % Used to test if the function returns an error
            if nargin < 4
                testCase.verifyError(@() isInformIdentification(X), errorId);
            else
                testCase.verifyError(@() isInformIdentification(X, U), errorId);
            end
        end
        
        function testVerifyEqual(testCase, X, U, expected)
            % Used to test equalities
            actual = isInformIdentification(X, U);
            testCase.verifyEqual(actual, expected);
        end
        
        function testVerifyInformative(testCase, exp_A, exp_B, X, U)
            % Used to test true statements
            if nargin < 5
                [bool, A, B] = isInformIdentification(X);
            else
                [bool, A, B] = isInformIdentification(X, U);
            end
            testCase.verifyTrue(bool);
            testCase.verifyEqual(A, exp_A);
            testCase.verifyEqual(B, exp_B);
        end
        
        function testVerifyNotInformative(testCase, X, U)
            % Used to test false statements
            if nargin < 3
                [bool, A, B] = isInformIdentification(X);
            else
                [bool, A, B] = isInformIdentification(X, U);
            end
            testCase.verifyFalse(bool);
            testCase.verifyEqual(A, []);
            testCase.verifyEqual(B, []);
        end
    end
end

