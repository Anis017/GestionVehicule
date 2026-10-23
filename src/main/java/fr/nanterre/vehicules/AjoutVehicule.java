package fr.nanterre.vehicules;

import java.util.List;

public class AjoutVehicule {
    // Ajoute le véhicule s'il n'est pas déjà dans le parc ;
    // renvoie true si l'ajout a eu lieu, false si c'est un doublon
    public static boolean ajouter(List<Vehicule> parc, Vehicule nouveau) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().equalsIgnoreCase(nouveau.getImmatriculation())) {
                return false;
            }
        }
        parc.add(nouveau);
        return true;
    }
}
