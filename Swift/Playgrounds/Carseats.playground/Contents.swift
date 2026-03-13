/*:
 # Train a Classifier
 */
import Foundation
import TabularData
import CreateML

let allCsvFile = Bundle.main.url(forResource: "Carseats_all",  withExtension: "csv")
let trainCsvFile = Bundle.main.url(forResource: "Carseats_train",  withExtension: "csv")
let testCsvFile = Bundle.main.url(forResource: "Carseats_test",  withExtension: "csv")

let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

let columns = ["Index", "Sales", "CompPrice", "Income", "Advertising", "Population", "Price", "ShelveLoc", "Age", "Education", "Urban", "US", "High"]

let types: [String : CSVType] = ["Index": .string,
                              "Sales": .double,
                              "CompPrice": .double,
                              "Income": .double,
                              "Advertising": .double,
                              "Population": .double,
                              "Price": .double,
                              "ShelveLoc": .string,
                              "Age": .double,
//                              "Education": .double,
                              "Urban": .string,
                              "US": .string,
                              "High": .string]

var allDf =
  try DataFrame(
    contentsOfCSVFile: allCsvFile!,
    columns: columns,
    types: types,
    options: options)

allDf.removeColumn("Index")
allDf.removeColumn("Sales")
allDf.removeColumn("Urban")

var trainDf =
  try DataFrame(
    contentsOfCSVFile: trainCsvFile!,
    columns: columns,
    types: types,
    options: options)

trainDf.removeColumn("Index")
trainDf.removeColumn("Sales")
trainDf.removeColumn("Urban")

var testDf =
  try DataFrame(
    contentsOfCSVFile: testCsvFile!,
    columns: columns,
    types: types,
    options: options)

testDf.removeColumn("Index")
testDf.removeColumn("Sales")
testDf.removeColumn("Urban")

//let (validationDfSlice, trainingDfSlice) = allDf.randomSplit(by: 0.2, seed: 12313)

let classifier = try MLClassifier(
  trainingData: trainDf,
  targetColumn: "High",
  featureColumns: ["CompPrice", "Income", "Advertising", "Population", "Price", "ShelveLoc", "Age", "Education"])
print(classifier)

var result: AnyColumn
var yesno: [Int] = []
var noyes: [Int] = []
var matrix: [[Int]] = [
    [0, 0],
    [0, 0]
]

do {
  result = try  classifier.predictions(from: testDf)
  print(result)
  for (index, pred) in result.enumerated() {
    if pred as! String == "Yes" && testDf["High"][index] == "Yes" {
      matrix[1][1] += 1
    } else if pred as! String == "No" && testDf["High"][index] == "No" {
      matrix[0][0] += 1
    } else if pred as! String == "Yes" && testDf["High"][index] == "No" {
      matrix[0][1] += 1
      noyes.append(index)
    } else {
      matrix[1][0] += 1
      yesno.append(index)
    }
  }
} catch {
  print(error.localizedDescription)
}
print("Yes/No: \(yesno)")
for j in yesno {
  print(testDf[row: Int(j)])
}
print("No/Yes: \(noyes)")
for j in noyes {
  print(testDf[row: Int(j)])
}
print(matrix)

let homePath = FileManager.default.homeDirectoryForCurrentUser
let filepath = homePath.appendingPathComponent("/Projects/R/ISLR2/Swift/CoreML/CarseatsClassifier.mlmodel")

let classifierMetadata = MLModelMetadata(
  author: "Rob Goedman",
  shortDescription: "Constructs a classifier",
                                         version: "0.1")
try classifier.write(to: filepath, metadata: classifierMetadata)

//print(allDf.shape)
//print(allDf[0..<10])
//print(trainDf.shape)
//print(trainDf[0..<10])
print(testDf.shape)
print(testDf[0..<20])



