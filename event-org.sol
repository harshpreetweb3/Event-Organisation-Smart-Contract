// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0; 

contract EventContract{
    struct Event{
        string name;
        uint date;
        address organizer;
        uint ticketCount;
        uint ticketRemain;
        uint price;
    }

    mapping(uint=>Event) public events;
    mapping(address=>mapping(uint=>uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint ticketCount) public {
        require(date>block.timestamp,"You can organize event for future date only");
        require(ticketCount>0,"You can organize events if and only if you have more than zero tickets");
        events[nextId]= Event(name, date, msg.sender,ticketCount, ticketCount, price);
        nextId++;
    }

    function buyTicket(uint id, uint quantity) public payable {
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date> block.timestamp, "Event has already occured");
        Event storage _event= events[id];
        require(msg.value==(quantity*_event.price), "Ether is not enough");
        require(_event.ticketRemain >= quantity, "Not enough tickets available");
        _event.ticketRemain-=quantity; 
        tickets[msg.sender][id]+=quantity;
    }

    function tranferTicket(address to, uint quantity, uint eventId) external{
        require(events[eventId].date!=0,"Event does not exist");
        require(events[eventId].date> block.timestamp, "Event has already occured");
        require(tickets[msg.sender][eventId] >= quantity, "These many tickets are not available");
        tickets[msg.sender][eventId]-=quantity;
        tickets[to][eventId]+=quantity;

    }




}
