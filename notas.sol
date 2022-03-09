pragma solidity 0.6.0;
pragma experimental ABIEncoderV2;

// -----------------------------------
//  ALUMNO   |    ID    |      NOTA
// -----------------------------------
//  Marcos |    77755N    |      5
//  Joan   |    12345X    |      9
//  Maria  |    02468T    |      2
//  Marta  |    13579U    |      3
//  Alba   |    98765Z    |      5

contract notas {
    //Direccion del profesor
    address public Profesor;

    //Constructor
    constructor () public {
        Profesor = msg.sender;
    }

    //Mapping para relacionar el has del alumno con su nota
    mapping (bytes32 => uint) Notas;

    //Array de alumnos que piden revision de examenes
    string [] revisiones;

    //
    event alumno_evaluado(bytes32, uint);
    event evento_revision(string);

    //Funcion para evaluar al alumno
    function evaluar (string memory _idAlumno, uint _nota) public UnicamenteProf (msg.sender) {
        //Hash del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Relacionar hash del alumno con la nota
        Notas[hash_idAlumno] = _nota;
        //Emitir un evento
        emit alumno_evaluado(hash_idAlumno, _nota);
    }

    modifier UnicamenteProf (address _direccion) {
        require(_direccion == Profesor, "No tienes permisos para ejecutar esta funcion");
        _;
    }

    function verNotas (string memory _idAlumno) public view returns (uint) {
        //Hash del alumno
        bytes32 hash_idAlumno = keccak256(abi.encodePacked(_idAlumno));
        //Nota del alumno
        uint nota_alumno = Notas[hash_idAlumno];
        return nota_alumno;
    }

    //Revision del examen
    function revision (string memory _idAlumno) public {
        revisiones.push(_idAlumno);
        emit evento_revision(_idAlumno);
    }

    //Ver solicitudes de revision
    function verRevisiones () public view UnicamenteProf(msg.sender) returns (string [] memory) {
        return revisiones;
    }
}