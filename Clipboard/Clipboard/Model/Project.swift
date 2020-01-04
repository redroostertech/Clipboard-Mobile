//
//  Project.swift
//  Clipboard
//
//  Created by Xavier La Rosa on 12/30/19.
//  Copyright © 2019 Xavier La Rosa. All rights reserved.
//

import Foundation


class Project {
    private var title = String()
    private var description = String()
    private var startDate = Date()
    private var team: Team?
    
    init(title: String){
        self.title = title
        self.startDate = Date.init()
    }
    
    func setTeam(team: String){
        self.team = Team(title: team)
    }
    func getTeam() -> Team?{
        guard let team = self.team else {return nil}
        return team
    }
    
    func setTitle(title: String){
        self.title = title
    }
    func getTitle() -> String? {
        return title
    }
    
    func setDescription(startDate: Date){
        self.startDate = startDate
    }
    func getDescription() -> String? {
        return description
    }
    
    func setStartDate(startDate: Date){
        self.startDate = startDate
    }
    func getStartDate() -> Date? {
        return startDate
    }
    
    func printEntireProject(){
        print("Printing project details")
        
        guard let title = getTitle() else {return}
        print("\tProject Title: "+title)
        
//        guard let description = getDescription() else {return}
//        print("\tProject Description: "+description)
        
        //print("\tProject Start Date: "+String(startDate))
        
        guard let teamTitle = getTeam()?.getTitle() else {return}
        print("\tTeam Title: "+teamTitle)
        
        guard let members = getTeam()?.getMembers() else {return}
        print("\tTeam Size: "+String(members.count))
        for member in members{
            print("\t\tMember: "+member.getName()+", role: "+member.getRole())
        }
        
    }
}