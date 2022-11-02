// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// se importa el contrato Ownable de la libreria de openzeppelin
import "@openzeppelin/contracts/access/Ownable.sol";
 
contract GymTickets2 is Ownable{
    
    address public immutable ADMIN;

    // Mapeo de usuarios (address) y tendran creditos (uint) - Key/Value
    mapping(address => uint) private users; // users(address) => credits
    // Mapeo para las clases (string) que alojara creditos (uint)
    mapping(string => uint) private classes;

    // 2 eventos para emitir logs sobre las clases y usuarios creados
    event createdClasses(
        string name,
        uint credits
    );
    event createdUsers(
        address user,
        uint credits
    );

    constructor(){
        ADMIN = msg.sender; 
    }

    // funcion para agregar clases, que tienen 2 atributos: nombre y creditos
    function addClasses(string memory _className, uint _credits) public onlyOwner {
        require(classes[_className] == 0, "La clase ya ha sido creada"); 
        classes[_className] = _credits;
        emit createdClasses(_className,_credits);
    }
    // funcion para agregar usuarios (address) y asignarles creditos
    function addUsers(address _userAddress, uint _credits) public {
        require(users[_userAddress] == 0, "El usuario ya existe o ya posee creditos");
        users[_userAddress] = _credits;
        emit createdUsers(_userAddress,_credits);
    } 
    // funcion para asistir a una clase
    // que valide si existe y que el usuario tenga creditos
    // si ambas son correctas, que reste creditos del usuario
    function goClass(string memory _className) public {
        require(classes[_className] > 0, "La clase no existe");
        require(users[msg.sender] >= classes[_className]);
        users[msg.sender] -= classes[_className]; 
    }
    // funcion para retornar un address y los creditos disponibles
    function viewCredits() public view returns(address, uint){
        return (msg.sender, users[msg.sender]);
    }
}