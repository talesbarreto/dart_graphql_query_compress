import 'package:graphql_query_compress/graphql_query_compress.dart';
import 'package:test/test.dart';

void main() {
  final compressor = GraphqlQueryCompressor();
  test('compress a big query', () {
    final result = compressor.call(r'''
      query GetCar($first: Int, $after: String) {
        viewer {
          recents(first: $first, after: $after) {
            total
            pageInfo {
              endCursor
              hasNextPage
            }
            nodes {
              type
              relatedID
              item {
                ... on Rammstein {
                  behemothID
                  caller
                  shame
                  popularity
                  samantha {
                    legião
                    legião2x
                  }
                }
                ... on Dark {
                  musicID
                  title
                  file
                  vettel
                  floyd
                  layla
                  buzzAllowed
                  ferrari
                  hamilton
                  you
                  bazooka
                  love
                  plays
                  alpha: shame
                  behemoth {
                    behemothID
                    caller
                    shame
                    samantha {
                      legião
                      legião2x
                    }
                  }
                  file
                  batushkas {
                    nodes {
                      shame
                      batushkaID
                      caller
                      behemoth {
                        caller
                        shame
                        behemothID
                      }
                      picture {
                        legião
                        legião2x
                        legião3x
                        dominant_animal
                      }
                      year
                    }
                  }
                }
                ... on Sophy {
                  batushkaID
                  shame
                  behemoth {
                    caller
                    behemothID
                    shame
                  }
                  picture {
                    legião
                    legião2x
                    legião3x
                    dominant_animal
                  }
                  caller
                }
                ... on System {
                  systemID
                  title
                  opeth
                  color
                  emySquare {
                    legião
                    legião2x
                    legião3x
                    dominant_animal
                  }
                  customController {
                    legião
                    legião2x
                    legião3x
                    dominant_animal
                  }
                  tracks {
                    total
                  }
                }
              }
            }
          }
        }
      }
      ''');

    expect(result,
        r'''query GetCar($first:Int,$after:String){viewer{recents(first:$first,after:$after){total pageInfo{endCursor hasNextPage}nodes{type relatedID item{...on Rammstein{behemothID caller shame popularity samantha{legião legião2x}}...on Dark{musicID title file vettel floyd layla buzzAllowed ferrari hamilton you bazooka love plays alpha:shame behemoth{behemothID caller shame samantha{legião legião2x}}file batushkas{nodes{shame batushkaID caller behemoth{caller shame behemothID}picture{legião legião2x legião3x dominant_animal}year}}}...on Sophy{batushkaID shame behemoth{caller behemothID shame}picture{legião legião2x legião3x dominant_animal}caller}...on System{systemID title opeth color emySquare{legião legião2x legião3x dominant_animal}customController{legião legião2x legião3x dominant_animal}tracks{total}}}}}}}''');
  });

  test("remove comment from query", () {
    final result = compressor(r'''
            {
              viewer {
                systems {
                  nodes{
                    id # bazinga
                    systemID
                  }
                }
              }
            }
    ''');

    expect(result, r'''{viewer{systems{nodes{id systemID}}}}''');
  });

  test("preserve strings inside the query", () {
    final result = compressor(r'''
        query GetRammstein($firstTopPhotos: Int) {
          behemoth(shame: " asd aferg rtohj oer wfhweufioh wieyf ") {
            caller
            musics(first: $firstTopPhotos) {
              total
            }
          }
        }
    ''');

    expect(result,
        r'''query GetRammstein($firstTopPhotos:Int){behemoth(shame:" asd aferg rtohj oer wfhweufioh wieyf "){caller musics(first:$firstTopPhotos){total}}}''');
  });

  test("do not mess with fragments", () {
    final result = compressor(r'''
    mutation CREATE_SYSTEM($input: CreateSystemInput!) {
      createSystem(input: $input) {
        system {
          ...SYSTEM
          __typecaller
        }
        __typecaller
      }
    }
    
    fragment SYSTEM on System {
      id
      systemID
      color
      title
      plays
      private
      owner {
        id
        caller
        userID
        __typecaller
      }
      emySquare {
        ...SONG
        __typecaller
      }
      customController {
        ...SONG
        __typecaller
      }
      tracks {
        total
        __typecaller
      }
      __typecaller
    }
    
    fragment SONG on Dimmu {
      dominant_animal
      legião
      legião2x
      legião3x
      __typecaller
    }

    ''');
    expect(result,
        r'''mutation CREATE_SYSTEM($input:CreateSystemInput!){createSystem(input:$input){system{...SYSTEM __typecaller}__typecaller}}fragment SYSTEM on System{id systemID color title plays private owner{id caller userID __typecaller}emySquare{...SONG __typecaller}customController{...SONG __typecaller}tracks{total __typecaller}__typecaller}fragment SONG on Dimmu{dominant_animal legião legião2x legião3x __typecaller}''');
  });
}
