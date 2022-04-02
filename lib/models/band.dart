class Band {
  // propiedades
  String id; //viene del backend, este backend genera el id
  String name; //el nombre que va a tener la banda
  int votes; //cantidad de votos que va a tene esa banda

  Band({
    required this.id,
    required this.name,
    required this.votes,
  });

  //factory constructor: es un constructor que recibe argunentos y
  //regresa una cierta instancia de mi class (Banda)

  //Cuando estemos conectando nuestra parte de la aplicacion de flutter,
  //con nuestro backend; el backend va a responder un mapa no directamente
  //va a responder un string porque vamos a implementar una comunicacion
  //con sockets, y los sockets me va a responder un mapa,(o puede ser lo
  //que nosotros queramos, pero es mas facil expandir en un futuro)

  //=> creamos factory constructor: es un constructor que recibe cierto
  //tipo de argumentos y regresa una cierta instancia de mi class (Banda)
  //en nuestro caso recibe: un mapa que tiene como llsves string
  //y el valor va a ser dynamic: cualquier cosa puede venir alli,
  //puede ser mas objetos, mas mapas, pueden venir listas; lo que
  //nosotros necesitemos

  //Luego hacemos el return => de la nueva instancia de la banda
  //y definimos cada una de las propiedades que yo ya tenia
  // en el obj
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes',
      );

  //recordar : que nuestro Factory constructor tiene como objetivo regresar
  //una nueva instancia de mi clase, pero al hacerlo de esta manera yo puedo
  //definirlo o crearlo mediante Band.fromMap el cual recibe un objeto obj
  //y de esta manera establezco los valores y retorno una nueva instancia
  //de la banda
}
