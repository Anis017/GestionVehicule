package fr.nanterre.vehicules;

import java.util.List;

public class SupprimerVehicule {
    // Supprime le véhicule ; renvoie true s'il existait
    public static boolean supprimer(List<Vehicule> parc, String immatriculation) {
        return parc.removeIf(v -> v.getImmatriculation().equals(immatriculation));
    }
}
