package fr.nanterre.vehicules;

import java.util.List;

public class RechercherVehicule {
    // Renvoie le véhicule trouvé, ou null s'il n'existe pas
    public static Vehicule rechercher(List<Vehicule> parc, String immatriculation) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().equals(immatriculation)) {
                return v;
            }
        }
        return null;
    }

    // Compte les véhicules d'une marque
    public static long compterParMarque(List<Vehicule> parc, String marque) {
        return parc.stream().filter(v -> v.getMarque().equals(marque)).count();
    }
}
