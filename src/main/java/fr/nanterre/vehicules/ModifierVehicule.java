package fr.nanterre.vehicules;

import java.util.List;

public class ModifierVehicule {
    // Modifie la marque, le modèle et l'année du véhicule ;
    // renvoie true si le véhicule existe, false sinon
    public static boolean modifier(List<Vehicule> parc, String immatriculation,
                                   String marque, String modele, int annee) {
        for (Vehicule v : parc) {
            if (v.getImmatriculation().equals(immatriculation)) {
                v.setMarque(marque);
                v.setModele(modele);
                v.setAnnee(annee);
                return true;
            }
        }
        return false;
    }
}
