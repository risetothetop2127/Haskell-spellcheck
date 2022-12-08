module ShellCheck.Analyzer (analyzeScript, ShellCheck.Analyzer.optionalChecks) where

import ShellCheck.Analytics
import ShellCheck.AnalyzerLib
import ShellCheck.Interface
import Data.List
import Data.Monoid
import qualified ShellCheck.Checks.Commands
import qualified ShellCheck.Checks.ControlFlow
import qualified ShellCheck.Checks.Custom
import qualified ShellCheck.Checks.ShellSupport


-- TODO: Clean up the cruft this is layered on
analyzeScript :: AnalysisSpec -> AnalysisResult
analyzeScript spec = newAnalysisResult {
    arComments =
        filterByAnnotation spec params . nub $
            runChecker params (checkers spec params)
}
  where
    params = makeParameters spec

checkers spec params = mconcat $ map ($ params) [
    ShellCheck.Analytics.checker spec,
    ShellCheck.Checks.Commands.checker spec,
    ShellCheck.Checks.ControlFlow.checker spec,
    ShellCheck.Checks.Custom.checker,
    ShellCheck.Checks.ShellSupport.checker
    ]

optionalChecks = mconcat $ [
    ShellCheck.Analytics.optionalChecks,
    ShellCheck.Checks.Commands.optionalChecks,
    ShellCheck.Checks.ControlFlow.optionalChecks
    ]
