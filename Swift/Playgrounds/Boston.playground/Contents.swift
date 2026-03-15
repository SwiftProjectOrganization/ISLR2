/*:
 # Train a Classifier
 */
import Foundation
import TabularData
import CreateML

let allCsvFile = Bundle.main.url(forResource: "Boston_all",  withExtension: "csv")
let trainCsvFile = Bundle.main.url(forResource: "Boston_train",  withExtension: "csv")
let testCsvFile = Bundle.main.url(forResource: "Boston_test",  withExtension: "csv")

let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

let columns = [ "index","crim","zn","indus","chas","nox",
                "rm","age","dis","rad","tax",
                "ptratio","lstat","medv"
]

let types: [String : CSVType] = ["index": .string,
                              "crim": .double,
                              "zn": .double,
                              "indus": .double,
                              "chas": .double,
                              "nox": .double,
                              "rm": .double,
                              "age": .double,
                              "dis": .double,
                              "rad": .double,
                              "tax": .double,
                              "ptratio": .double,
                              "lstat": .double,
                              "medv": .double]

var allDf =
  try DataFrame(
    contentsOfCSVFile: allCsvFile!,
    columns: columns,
    types: types,
    options: options)

allDf.removeColumn("index")

print(allDf[0..<10])

var trainDf =
  try DataFrame(
    contentsOfCSVFile: trainCsvFile!,
    columns: columns,
    types: types,
    options: options)

trainDf.removeColumn("index")

print(trainDf[0..<10])

var testDf =
  try DataFrame(
    contentsOfCSVFile: testCsvFile!,
    columns: columns,
    types: types,
    options: options)

testDf.removeColumn("index")

print(testDf[0..<10])

let classifier = try MLClassifier(
  trainingData: trainDf,
  targetColumn: "medv",
  featureColumns: ["crim","zn","indus","chas","nox",
 "rm","age","dis","rad","tax",
 "ptratio","lstat"])
print(classifier)

var result: AnyColumn
var yesno: [Int] = []
var noyes: [Int] = []
var matrix: [[Int]] = [
    [0, 0],
    [0, 0]
]
/*


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

*/

