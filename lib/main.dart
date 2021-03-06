//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords>{
  final _suggestions = <WordPair>[];
  final _saved = <WordPair>{};
  final _biggerFont = const TextStyle(fontSize: 18);
  Widget _builtSuggestions(){
    return ListView.builder(
      padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext _context, int i){
        if(i.isOdd) return Divider();
        final int index = i ~/2;
        if(index >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
        }
    );
  }

  Widget _buildRow(WordPair pair){
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title : Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null ,
      ),
      onTap: (){
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)],
      ),
      body: _builtSuggestions(),
    );
  }
  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context){
          final tiles = _saved.map(
              (WordPair pair){
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
          );
          final divided = tiles.isNotEmpty ?
              ListTile.divideTiles(context: context, tiles: tiles).toList() :
              <Widget>[];
          return Scaffold(
            appBar : AppBar(
                title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        }
      )
    );
  }
}

