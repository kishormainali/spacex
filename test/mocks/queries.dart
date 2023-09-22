Map<String, dynamic> emptyQuery = {
  'query': {},
  'options': {
    'limit': 10,
    'page': 1,
    'select': {
      'name': 1,
      'date_local': 1,
      'success': 1,
      'failures': 1,
      'upcoming': 1,
      'links.patch': 1,
    },
    'sort': {
      'date_local': 'asc',
    },
  },
};

Map<String, dynamic> searchQuery = {
  'query': {
    '\$text': {
      '\$search': '"test"',
    }
  },
  'options': {
    'limit': 10,
    'page': 1,
    'select': {
      'name': 1,
      'date_local': 1,
      'success': 1,
      'failures': 1,
      'upcoming': 1,
      'links.patch': 1,
    },
    'sort': {
      'date_local': 'asc',
    },
  },
};
