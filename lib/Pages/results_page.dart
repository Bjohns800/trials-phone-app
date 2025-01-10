import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> submittedResults;

  const ResultsPage({super.key, required this.submittedResults});

  // Function to generate unique player IDs
  List<String> _getUniquePlayerIds(List<Map<String, dynamic>> results) {
    Set<String> playerIds = {};
    for (var result in results) {
      playerIds.add(result['player_id'].toString());
    }
    return playerIds.toList();
  }

  // Function to generate the table rows dynamically
  List<DataRow> _generateRows(List<Map<String, dynamic>> results, List<String> uniquePlayerIds) {
    // Create a table with placeholders for each player and each score
    List<DataRow> rows = [];
    
    for (var playerId in uniquePlayerIds) {
      // Find all scores for this player
      var playerResults = results.where((result) => result['player_id'].toString() == playerId).toList();
      
      // Create a list of 4 scores (fill with empty strings if necessary)
      List<String> scores = List.filled(4, "", growable: false);
      int scoreIndex = 0;
      
      // Fill in the scores for this player
      for (var result in playerResults) {
        scores[scoreIndex] = result['score'].toString();
        scoreIndex++;
      }
      
      // Create a row with the player ID and scores
      List<DataCell> cells = [
        DataCell(Text(playerId)),
        DataCell(Text(scores[0])),
        DataCell(Text(scores[1])),
        DataCell(Text(scores[2])),
        DataCell(Text(scores[3])),
      ];
      
      // Add the row to the list of rows
      rows.add(DataRow(cells: cells));
    }
    
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    // Get unique player IDs from the data
    List<String> uniquePlayerIds = _getUniquePlayerIds(submittedResults);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results Page'),
        centerTitle: true,
      ),
      body: submittedResults.isEmpty
          ? const Center(child: Text('No results available'))
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Player Number')),
                  DataColumn(label: Text('Score 1')),
                  DataColumn(label: Text('Score 2')),
                  DataColumn(label: Text('Score 3')),
                  DataColumn(label: Text('Score 4')),
                ],
                rows: _generateRows(submittedResults, uniquePlayerIds),
              ),
            ),
    );
  }
}
