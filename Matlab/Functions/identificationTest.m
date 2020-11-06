classdef identificationTest < matlab.unittest.TestCase
%IDENTIFICATIONTEST Unit testing for identification(X,U)
%   This file contains all unit test used to verify the implementation is
%   working as expected. The test can be run using:
%     result = run(isIdentifiableTest)
%   The unit test are implemented using matlab.unittest.TestCase
  
    % Unit tests for the identification(X) function
    methods (Test)
        function testEmptyX(testCase)
            % Test empty X
            X = [];
            errorId = 'testDataInput:EmptyStateData';
            testCase.verifyError(@() isIdentifiable(X), errorId);
        end
        
        function testScalarX(testCase)
            % Test scalar X
            X = 1;
            
        end
        
        function testRowX(testCase)
            % Test row X 
            
        end
        
        function testMatrixX(testCase)
            % Test matrix X
            
        end
        
        function testNonNumeric(testCase)
            % Test non numeric X
            
        end

    end
    
    % Unit tests for the isIdentifiable(X,U) function
    methods (Test)
        function test(testCase)
            % Test
            
        end
        
        function test(testCase)
            % Test
            
        end
        
        function test(testCase)
            % Test
            
        end
        
        function test(testCase)
            % Test
            
        end
    end
end

