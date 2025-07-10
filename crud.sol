// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleContract {
    uint8 private UserCount = 0;

    struct Person {
        uint8 Id;
        uint64 FavoriteNumber;
        string Pass;
    }
    struct PublicPerson {
    uint8 Id;
    string PersonName;
    uint64 FavoriteNumber;
    }

    mapping(string => Person) private UserDatabase;

    string[] private usernames; // Needed to iterate over all users

    function AddPerson(string memory _personName, uint64 _favoriteNumber, string memory _pass) public {
        require(UserDatabase[_personName].Id == 0, "User already exists"); // prevent overwrite
        UserCount += 1;
        UserDatabase[_personName] = Person(UserCount, _favoriteNumber, _pass);
        usernames.push(_personName);
    }

    function GetUserByName(string memory _personName) public view returns (uint64) {
        require(UserDatabase[_personName].Id != 0, "User not found");
        return UserDatabase[_personName].FavoriteNumber;
    }

    function GetAllPersons() public view returns (PublicPerson[] memory) {
        PublicPerson[] memory allPersons = new PublicPerson[] (usernames.length);
        for (uint i = 0; i < usernames.length; i++) {
            allPersons[i]=(PublicPerson(UserDatabase[usernames[i]].Id,usernames[i],UserDatabase[usernames[i]].FavoriteNumber));
        }
        return allPersons;
    }

    function UpdateFavoriteNumber(string memory _username, string memory _pass, uint64 _newFavoriteNumber) public {
        require(UserDatabase[_username].Id != 0, "User Not Found");
        require(
            keccak256(bytes(UserDatabase[_username].Pass)) == keccak256(bytes(_pass)),
            "Incorrect password"
        );
        UserDatabase[_username].FavoriteNumber = _newFavoriteNumber;
    }

    function RemovePerson(string memory _username, string memory _pass) public {
        require(UserDatabase[_username].Id != 0, "User Not Found");
        require(
            keccak256(bytes(UserDatabase[_username].Pass)) == keccak256(bytes(_pass)),
            "Incorrect password"
        );

        // Remove from mapping
        delete UserDatabase[_username];

        // Remove from usernames array
        for (uint i = 0; i < usernames.length; i++) {
            if (keccak256(bytes(usernames[i])) == keccak256(bytes(_username))) {
                usernames[i] = usernames[usernames.length - 1]; // swap with last
                usernames.pop(); // remove last
                break;
            }
        }
    }
}
